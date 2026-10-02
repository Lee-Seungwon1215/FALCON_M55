#!/usr/bin/env python3
"""Explicit-device Flash backup, gated benchmark, non-halting monitoring.

Only the verified blank high-Flash slot may be programmed or erased. The
original boot image and option bytes are never written. All Flash operations
require an identity check and a previously verified full backup.
"""
import argparse
import datetime
import fcntl
import hashlib
import json
import math
import os
from pathlib import Path
import socket
import statistics
import struct
import subprocess
import sys
import tempfile
import time

ROOT = Path(__file__).resolve().parent
REF = ROOT.parent / "ref"
BUILD = ROOT / "build"
LOGS = ROOT / "logs"
REPORT = ROOT / "result.md"
RECORD = ROOT / "session.json"
STATUS = ROOT / "status.json"
FLASH_BASE, FLASH_SIZE = 0x08000000, 0x200000
SLOT_BASE, SLOT_SIZE = 0x081C0000, 0x40000
PAGE_SIZE = 4096
MAILBOX, HEADER_WORDS, MAILBOX_WORDS = 0x20030000, 34, 634
READY, RUNNING, DONE, FAILED, GO = 0x52454144, 0x52554E21, 0x600D0000, 0xBAD00000, 0x474F3130
SERIAL = "066DFF363355473043205442"
COMMIT = "a5f15894bf1a68017074650d5298cecf9bb29a79"
EXPECTED_UID = [3080202, 1447776277, 540619057]
EXPECTED_OPTR = 4293916842

def utc():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()

def digest(data):
    return hashlib.sha256(data).hexdigest()

def save_json(path, value):
    # Atomic replacement prevents readers seeing half-written JSON.
    tmp = path.with_name(path.name + ".tmp")
    tmp.write_text(json.dumps(value, indent=2, ensure_ascii=False) + "\n")
    tmp.replace(path)

def log(message):
    line = utc() + " " + str(message)
    print(line, flush=True)
    LOGS.mkdir(exist_ok=True)
    with (LOGS / "events.log").open("a") as f:
        f.write(line + "\n")

class OpenOCD:
    def __init__(self):
        self.sock = socket.create_connection(("127.0.0.1", 6674), timeout=10)
        self.sock.settimeout(240)

    def command(self, cmd, quiet=False):
        if not quiet:
            log("OpenOCD: " + cmd)
        packet = ("set _fndsa_rc [catch {" + cmd + "} _fndsa_msg]; "
                  'format "%d:%s" $_fndsa_rc $_fndsa_msg\x1a')
        self.sock.sendall(packet.encode())
        data = bytearray()
        while b"\x1a" not in data:
            block = self.sock.recv(65536)
            if not block:
                raise RuntimeError("OpenOCD disconnected")
            data.extend(block)
        reply = bytes(data).split(b"\x1a", 1)[0].decode()
        code, result = reply.split(":", 1)
        if code != "0":
            raise RuntimeError(cmd + ": " + result)
        if not quiet and result:
            log(result)
        return result

    def read(self, addr, count, quiet=True):
        response = self.command(f"read_memory 0x{addr:08x} 32 {count}", quiet)
        values = [int(x, 0) for x in response.split()]
        if len(values) != count:
            raise RuntimeError("Wrong number of words from debugger")
        return values

    def close(self):
        self.sock.close()

def identity(ocd):
    result = {
        "cpuid": ocd.read(0xE000ED00, 1)[0],
        "device_id": ocd.read(0xE0042000, 1)[0],
        "uid": ocd.read(0x1FFF7590, 3),
        "flash_kib": ocd.read(0x1FFF75E0, 1)[0] & 0xFFFF,
        "flash_optr": ocd.read(0x40022020, 1)[0],
    }
    assert result["cpuid"] == 0x410FC241
    assert result["device_id"] & 0xFFF == 0x470
    assert result["flash_kib"] == 2048
    assert result["flash_optr"] & 0xFF == 0xAA, "Read protection must be disabled"
    assert result["uid"] == EXPECTED_UID, "Unexpected MCU UID; refusing board mutation"
    assert result["flash_optr"] == EXPECTED_OPTR, "Option bytes changed since the identified experiment"
    # Capture and refuse enabled write/PCROP protection. Never clear protection.
    protection = {}
    for bank, base in [(1, 0x40022024), (2, 0x40022044)]:
        pcrop_start, pcrop_end, wrpa, wrpb = ocd.read(base, 4)
        protection[f"bank{bank}"] = [pcrop_start, pcrop_end, wrpa, wrpb]
        assert (pcrop_start & 0x1FFFF) > (pcrop_end & 0x1FFFF), "PCROP protection enabled"
        for wrp in [wrpa, wrpb]:
            assert (wrp & 0xFF) > ((wrp >> 16) & 0xFF), "Write protection enabled"
    result["flash_protection"] = protection
    return result

def check_identity(ocd, session):
    actual = identity(ocd)
    assert actual == session["identity"], "Device or option bytes changed; refusing mutation"

def source_check():
    head = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=REF, text=True).strip()
    dirty = subprocess.check_output(["git", "status", "--porcelain", "--untracked-files=no"], cwd=REF, text=True)
    assert head == COMMIT and not dirty, "The fixed upstream source has changed"
    return {p.name: digest(p.read_bytes()) for p in sorted(REF.iterdir()) if p.suffix in [".c", ".h", ".s"]}

def unpack_header(words):
    names = ["magic", "version", "state", "error", "runs", "degree", "iteration", "operation",
             "cpuid", "device_id", "core_clock_hz", "flash_acr", "pwr_cr1", "pwr_cr5",
             "rcc_cr", "rcc_cfgr", "vtor", "primask", "assembly", "gcc_version"]
    h = dict(zip(names, words[:20]))
    h["counts"] = [words[20:23], words[23:26]]
    h["warmup_fingerprint"] = words[26:28]
    h["fingerprint"] = words[28:30]
    h["command"] = words[30]
    h["fault_registers"] = words[31:34]
    return h

def write_report(status, session, results=None):
    h = status.get("header", {})
    lines = ["# Stage A: FN-DSA M4 선행 구현 재측정 / -O3 / 100회", "",
        f"상태: **{status['phase']}**. 갱신: `{status['updated_utc']}`.", "",
        "현재 연결된 STM32L4R/L4S에서 수행하는 대체 보드 실험이다. 논문 당시 코드·F407의 완전 재현이 아니다. 기존 실험은 보존하고 별도 새 세션으로 측정한다.", "",
        "Stage B의 mlkem-native 기반 M55 환경과는 클럭·컴파일러·메모리·OS·반복 통계 방식이 다르다. A→B를 순수 코어 개선 또는 TCM 단독 효과로 해석하지 않는다. B가 후속 M55 최적화의 기준점이다.", "",
        "## 조건", "", "| 항목 | 실제 측정 설정 |", "|---|---|",
        f"| 소스 | `fn-dsa_m4/ref`, `{COMMIT}`; 원본 C/헤더/어셈블리 수정 없음 |",
        "| 컴파일러 | Arm GNU Toolchain 13.2.Rel1 / GCC 13.2.1 |",
        "| 컴파일 | `-O3 -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16`; LTO/fast-math 없음 |",
        "| M4 최적화 | `FNDSA_ASM_CORTEXM4=1`, 제공된 5개 `.s` 및 인라인 어셈블리 사용 |",
        "| 연산 경로 | 키 생성 고정소수점; 서명 정수 기반 FP64 에뮬레이션; MVE 없음 |",
        f"| 장비 | STM32L4R/L4S, CPUID `0x{session['identity']['cpuid']:08x}`, ST-LINK `{SERIAL}` |",
        "| 클럭 | 내부 MSI, 공칭 CPU/HCLK 24 MHz, APB1 12 MHz, APB2 24 MHz; Range 1 normal |",
        "| Flash 설정 | I/D cache OFF, prefetch OFF, **1 wait state** |",
        "| 코드·상수 | Flash `0x081C0000`부터, 최대 256 KiB의 백업·공백 확인된 영역 |",
        "| 데이터·스택 | SRAM3 (`0x20040000`부터), stack top `0x200A0000` |",
        "| 결과·진행 상태 | 별도 SRAM2 `0x20030000`; 계측 구간 밖에서 갱신 |",
        "| 반복 | FN-DSA-512/1024 각각 키 생성·서명·검증 100회; 크기별 워밍업 각 1회 제외 |",
        "| 입력 | 매회 새 결정적 시드로 키 생성 → 그 키로 서명 → 해당 서명 검증; 메시지 `blah` 4바이트, 빈 context, RAW |",
        "| 난수 | 내부 SHAKE256, seeded/temp API; 외부 RNG 비용 제외 |",
        "| 타이머 | DWT CYCCNT, 인터럽트/SysTick 비활성화, API 전체 시간; 내부 재시도 포함 |",
        "| 제외 비용 | 시드 준비, 체크섬, 로그, 통계 처리; 함수별 프로파일링 훅 없음 |",
        "| 모니터링 | 약 60초마다 SRAM2 상태 136바이트 읽기; 본 측정 중 코어 halt/reset/Flash 쓰기 없음 |", "",
        "모니터링은 CPU를 정지시키지 않고 알고리즘 데이터와 다른 SRAM bank를 읽는다. 디버그 버스 접근의 영향이 수학적으로 0이라고 보장하지는 않는다.", "",
        "DWT는 32비트 차분을 사용한다. API 한 번이 2^32 cycles(24 MHz에서 약 179초) 미만이라는 전제가 있으며, 다중 wrap 검출용 인터럽트는 넣지 않았다.", "",
        "Flash 0 WS는 이 칩에서 HCLK 20 MHz 이하까지만 허용되므로 24 MHz에서는 1 WS를 사용한다. [ST RM0432 §3.3.3, Table 12](https://www.st.com/resource/en/reference_manual/dm00310109-stm32l4-series-advanced-armbased-32bit-mcus-stmicroelectronics.pdf)", "",
        "논문과 다른 점: L4R/L4S 보드·SRAM 배치·Flash 1 WS·클럭 소스·ST HAL 초기화, 최신 소스/스킴, -O3, 100회다. 최신 코드의 공개키 NTT 표현·mu 처리 등도 포함하므로 논문 대비 차이를 -O3 효과만으로 해석하면 안 된다.", "",
        "## 진행 및 정확성", ""]
    if h:
        lines += [f"- 현재 차수: {h['degree']}, 반복 인덱스: {h['iteration']}, 단계: {['키 생성','서명','검증'][min(h['operation'],2)]}.",
            f"- 완료 횟수 [키 생성, 서명, 검증]: 512 `{h['counts'][0]}`, 1024 `{h['counts'][1]}`.",
            f"- 상태 `0x{h['state']:08x}`, 오류 `0x{h['error']:08x}`.",
            f"- 설정값: core_clock={h['core_clock_hz']}, FLASH_ACR=`0x{h['flash_acr']:08x}`, VTOR=`0x{h['vtor']:08x}`, PRIMASK={h['primask']}."]
    lines += [f"- 워밍업 검증: {session.get('warmup_verified', False)}. 정상 서명 검증·변조 서명 거부 및 두 크기의 호스트 체크섬 대조.",
        "- 전체 업스트림 portable C 테스트/KAT는 앞선 참조 프로파일링에서 통과했다. 이번 M4 경로는 별도 워밍업 대조와 100회 생성·서명·검증으로 확인한다.",
        "- 결정적 시드는 벤치마크 전용이다. FNV-1a 체크섬 일치는 진단용이며 암호학적 동등성 증명은 아니다.", ""]
    if session.get("collection_note"):
        lines += ["종료 후 수집 복구: 모든 100회 계산이 끝나 WFI 대기 상태에 들어간 뒤, 실행 중 디버그 읽기가 0을 반환했다. 코어를 halt한 후 DONE 상태·600개 사이클·최종 체크섬을 검증해 수집했다. 계측 중 halt한 것이 아니며 재측정도 하지 않았다. 처음의 수집 오류와 복구 과정은 아래 로그에 보존했다.", ""]
    if results:
        lines += ["## 측정 결과", "", "표준편차는 표본 표준편차다. 이상치를 임의로 제외하지 않았다. 시간은 공칭 24 MHz 환산값이다.", "",
            "| 크기 | 단계 | 횟수 | 평균 cycles | 중앙값 | 표준편차 | 최소 | 최대 | 평균 ms |",
            "|---|---|---:|---:|---:|---:|---:|---:|---:|"]
        for d in results["measurements"]:
            for name, data in d["operations"].items():
                lines.append(f"| {d['degree']} | {name} | {data['count']} | {data['mean']:,.2f} | {data['median']:,.1f} | {data['stdev']:,.2f} | {data['min']:,} | {data['max']:,} | {data['mean']/24000:.3f} |")
        lines += ["", "### 회차별 원시 사이클", "", "```csv", "degree,index,keygen_cycles,sign_cycles,verify_cycles"]
        for d in results["measurements"]:
            for j in range(100):
                vals = [d["operations"][op]["cycles"][j] for op in ["keygen", "sign", "verify"]]
                lines.append(",".join(map(str, [d["degree"], j + 1] + vals)))
        lines += ["```", ""]
    else:
        lines += ["## 측정 결과", "", "아직 최종 수치가 없다. 진행 중 자료를 완료된 결과로 표시하지 않는다.", ""]
    lines += ["## Flash 보존", "",
        f"- 전체 2 MiB 백업: `{session['backup_file']}`.",
        f"- SHA-256: `{session['backup_sha256']}`; 장비에 대한 verify_image 검증 완료.",
        "- 사용 슬롯은 사전에 모든 바이트가 0xFF임을 확인했다. 기존 boot image와 option bytes는 쓰지 않는다.",
        f"- 측정 슬롯 복원 상태: **{session.get('restoration', '아직 기록 전')}**.",
        "- 복원 시 측정용으로 쓴 Flash 페이지만 erase한 뒤 전체 Flash를 백업과 검증한다. MCU의 실행 중 RAM 상태까지 복원하는 것은 아니다.", "",
        "## 로그·재현", "",
        "- [빌드 로그](logs/build.log), [실행·모니터링·복원 로그](logs/events.log), [진행 상태](status.json).",
        "- [세션 메타데이터](session.json), [원시 결과 JSON](results.json), [측정 코드](benchmark.c), [제어·모니터링 코드](controller.py).",
        "- [진행 확인·복구 방법](README.md).",
        "- [논문 최적화 요약](../../REFERENCE/falcon_m4_implementation.md).", ""]
    events = LOGS / "events.log"
    if events.exists():
        lines += ["### 실행 로그", "", "```text", events.read_text().rstrip(), "```", ""]
    build_log = LOGS / "build.log"
    if build_log.exists():
        lines += ["### 빌드 로그", "", "```text", build_log.read_text().rstrip(), "```", ""]
    tmp = REPORT.with_name(REPORT.name + ".tmp")
    tmp.write_text("\n".join(lines))
    tmp.replace(REPORT)

def prepare():
    assert not RECORD.exists(), "Existing session: inspect it; do not overwrite its backup metadata"
    source_hashes = source_check()
    ocd = OpenOCD()
    ocd.command("halt")
    ident = identity(ocd)
    folder = ROOT / "backups"
    folder.mkdir(exist_ok=True)
    backupdir = Path(tempfile.mkdtemp(prefix="m4-original-", dir=folder))
    backup = backupdir / "flash_08000000_2mib.bin"
    ocd.command(f"dump_image {{{backup}}} 0x{FLASH_BASE:08x} 0x{FLASH_SIZE:x}")
    content = backup.read_bytes()
    assert len(content) == FLASH_SIZE
    ocd.command(f"verify_image {{{backup}}} 0x{FLASH_BASE:08x} bin")
    slot = content[SLOT_BASE - FLASH_BASE:]
    assert slot == b"\xff" * SLOT_SIZE, "Chosen high-Flash slot is not empty; refusing to overwrite user data"
    (backupdir / "original_slot_081c0000.bin").write_bytes(slot)
    session = {"created_utc": utc(), "identity": ident, "stlink_serial": SERIAL,
        "source_commit": COMMIT, "source_hashes": source_hashes,
        "backup_file": str(backup), "backup_sha256": digest(content),
        "blank_slot_base": SLOT_BASE, "blank_slot_size": SLOT_SIZE,
        "backup_verified": True, "restoration": "아직 기록 전"}
    save_json(RECORD, session)
    status = {"phase": "Flash 백업 완료 / 빌드 준비", "updated_utc": utc()}
    save_json(STATUS, status)
    write_report(status, session)
    log("Fresh full backup verified; entire high 256 KiB slot is already blank (read-only check). Original boot image will be preserved.")
    ocd.close()

def symbol(name):
    for line in (BUILD / "symbols.txt").read_text().splitlines():
        parts = line.split()
        if len(parts) == 3 and parts[2] == name:
            return int(parts[0], 16)
    raise RuntimeError("Missing symbol " + name)

def restore(ocd, session):
    check_identity(ocd, session)
    content = Path(session["backup_file"]).read_bytes()
    assert digest(content) == session["backup_sha256"]
    assert content[SLOT_BASE - FLASH_BASE:] == b"\xff" * SLOT_SIZE
    length = session["written_length"]
    assert 0 < length <= SLOT_SIZE and length % PAGE_SIZE == 0
    ocd.command("halt")
    # Restore only the pages this session used. Never erase the boot image.
    ocd.command(f"flash erase_address 0x{SLOT_BASE:08x} 0x{length:x}")
    ocd.command(f"verify_image {{{session['backup_file']}}} 0x{FLASH_BASE:08x} bin")
    session["restoration"] = "측정 슬롯 erase 완료; 전체 Flash가 백업과 일치함을 verify_image로 확인"
    session["restored_utc"] = utc()
    save_json(RECORD, session)
    ocd.command("reset halt")
    log("Restoration verified. Original Flash restored; board left reset/halted.")

def validate_header(h):
    assert h["magic"] == 0x464D3450 and h["version"] == 1 and h["runs"] == 100
    assert h["core_clock_hz"] == 24000000 and h["flash_acr"] & 0x70F == 1
    assert h["vtor"] == SLOT_BASE and h["primask"] == 1
    assert h["assembly"] == 1 and h["gcc_version"] == 130201
    assert h["cpuid"] == 0x410FC241 and h["device_id"] & 0xFFF == 0x470

def run():
    session = json.loads(RECORD.read_text())
    assert session["restoration"] == "아직 기록 전", "Session has already programmed Flash; inspect/recover instead of rerunning"
    assert source_check() == session["source_hashes"]
    oracle = json.loads((BUILD / "host_oracle.json").read_text())
    binary = BUILD / "fndsa_m4.bin"
    data = binary.read_bytes()
    assert 0 < len(data) <= SLOT_SIZE
    sp, reset_handler = struct.unpack_from("<II", data)
    assert sp == 0x200A0000 and SLOT_BASE <= reset_handler < SLOT_BASE + SLOT_SIZE
    assert symbol("bench_results") == MAILBOX
    session["elf_sha256"] = digest((BUILD / "fndsa_m4.elf").read_bytes())
    session["binary_sha256"] = digest(data)
    session["written_length"] = math.ceil(len(data) / PAGE_SIZE) * PAGE_SIZE
    session["host_oracle"] = oracle
    session["harness_hashes"] = {p.name: digest(p.read_bytes()) for p in sorted(ROOT.iterdir())
        if p.suffix in [".c", ".h", ".ld", ".py", ".cfg"] or p.name == "Makefile"}
    session["restoration"] = "측정용 Flash 기록 시작 / 복원 전"
    ocd = OpenOCD()
    check_identity(ocd, session)
    ocd.command("reset halt")
    # Check the original Flash again immediately before the first mutation.
    backup = Path(session["backup_file"])
    assert digest(backup.read_bytes()) == session["backup_sha256"]
    ocd.command(f"verify_image {{{backup}}} 0x{FLASH_BASE:08x} bin")
    save_json(RECORD, session)
    try:
        status = {"phase": "측정 이미지 기록 / 워밍업 검증 중", "updated_utc": utc()}
        save_json(STATUS, status)
        write_report(status, session)
        ocd.command(f"flash write_image erase {{{binary}}} 0x{SLOT_BASE:08x} bin")
        ocd.command(f"verify_image {{{binary}}} 0x{SLOT_BASE:08x} bin")
        for reg, value in [("sp", sp), ("msp", sp), ("psp", sp), ("xpsr", 0x01000000),
                           ("primask", 0), ("basepri", 0), ("faultmask", 0), ("control", 0)]:
            ocd.command(f"reg {reg} 0x{value:08x}")
        ocd.command(f"resume 0x{reset_handler & ~1:08x}")
        began = time.monotonic()
        h = {}
        while time.monotonic() - began < 240:
            time.sleep(2)
            h = unpack_header(ocd.read(MAILBOX, HEADER_WORDS))
            if h["state"] == FAILED:
                raise RuntimeError("Warmup failure: " + json.dumps(h))
            if h["state"] == READY:
                break
        assert h.get("state") == READY, "Warmup did not reach ready state"
        validate_header(h)
        assert h["warmup_fingerprint"] == oracle["warmup_fingerprint"], "M4 warmup differs from scalar host oracle"
        session["warmup_verified"] = True
        session["started_utc"] = utc()
        save_json(RECORD, session)
        log("Both warmups and tampered-signature checks passed; scalar host fingerprints match.")
        ocd.command(f"write_memory 0x{MAILBOX + 30 * 4:08x} 32 {{0x{GO:08x}}}")
        began = time.monotonic()
        previous, last_change = None, began
        while True:
            h = unpack_header(ocd.read(MAILBOX, HEADER_WORDS))
            validate_header(h)
            status = {"phase": "100회 본 측정 진행 중", "updated_utc": utc(),
                      "elapsed_seconds": round(time.monotonic() - began, 1), "header": h}
            if h["counts"] != previous:
                previous, last_change = h["counts"], time.monotonic()
            if time.monotonic() - last_change > 300:
                status["warning"] = "5분 이상 완료 횟수 변화 없음; 확인 필요 (자동 reset하지 않음)"
            save_json(STATUS, status)
            write_report(status, session)
            log(f"progress counts={h['counts']}, degree={h['degree']}, operation={h['operation']}, state=0x{h['state']:08x}, error={h['error']}")
            if h["state"] in [DONE, FAILED]:
                break
            if time.monotonic() - began > 14400:
                raise RuntimeError("4-hour limit reached; not accepting incomplete timings")
            time.sleep(60)
        # All timed calls have finished; now stopping the core is harmless.
        ocd.command("halt")
        words = ocd.read(MAILBOX, MAILBOX_WORDS)
        h = unpack_header(words)
        (LOGS / "mailbox.bin").write_bytes(struct.pack("<" + "I" * len(words), *words))
        assert h["state"] == DONE and h["error"] == 0, json.dumps(h)
        assert h["counts"] == [[100, 100, 100], [100, 100, 100]]
        assert h["fingerprint"] == oracle["fingerprint"], "Final host/M4 fingerprints differ"
        results = {"recorded_utc": utc(), "source_commit": COMMIT, "header": h, "measurements": []}
        for d in range(2):
            ops = {}
            for op, name in enumerate(["keygen", "sign", "verify"]):
                offset = HEADER_WORDS + (d * 3 + op) * 100
                cycles = words[offset:offset + 100]
                assert len(cycles) == 100 and min(cycles) > 0
                ops[name] = {"count": 100, "mean": statistics.mean(cycles), "median": statistics.median(cycles),
                    "stdev": statistics.stdev(cycles), "min": min(cycles), "max": max(cycles), "cycles": cycles}
            results["measurements"].append({"degree": 512 << d, "operations": ops})
        save_json(ROOT / "results.json", results)
        log("All 600 timed operations passed, and both final fingerprints match the scalar host oracle.")
        restore(ocd, session)
        status = {"phase": "측정·검증·Flash 복원 완료", "updated_utc": utc(), "header": h}
        save_json(STATUS, status)
        write_report(status, session, results)
    except Exception as exc:
        log("ERROR: " + repr(exc))
        status = {"phase": "오류로 중단 / 결과 미확정", "updated_utc": utc(), "error": repr(exc)}
        save_json(STATUS, status)
        try:
            restore(ocd, session)
        except Exception as recovery_error:
            log("Recovery requires attention: " + repr(recovery_error))
            session["restoration"] = "복원 확인 필요: " + repr(recovery_error)
            save_json(RECORD, session)
        write_report(status, session)
        raise
    finally:
        ocd.close()

def launch():
    if STATUS.exists() and "진행 중" in json.loads(STATUS.read_text()).get("phase", ""):
        raise RuntimeError("A measurement is already marked running")
    LOGS.mkdir(exist_ok=True)
    with (LOGS / "background.log").open("a") as output:
        child = subprocess.Popen(["/usr/bin/caffeinate", "-i", sys.executable, str(__file__), "run"],
            cwd=ROOT, stdin=subprocess.DEVNULL, stdout=output, stderr=subprocess.STDOUT,
            start_new_session=True)
    save_json(ROOT / "background.json", {"pid": child.pid, "launched_utc": utc()})
    print("Launched background controller PID", child.pid)

def recover():
    """Recover after an interrupted controller, never concurrently with it."""
    session = json.loads(RECORD.read_text())
    assert "written_length" in session, "This session has not recorded a programmed range"
    ocd = OpenOCD()
    try:
        restore(ocd, session)
        status = {"phase": "수동 복원 검증 완료 / 측정 결과는 기존 상태 참고", "updated_utc": utc()}
        save_json(STATUS, status)
        result_path = ROOT / "results.json"
        write_report(status, session, json.loads(result_path.read_text()) if result_path.exists() else None)
    finally:
        ocd.close()

def finalize_completed():
    """Recover finished data after WFI made running-target SRAM reads zero.

    This command is for the confirmed-complete interrupted collection only;
    it refuses any state other than DONE and never fabricates missing cycles.
    """
    session = json.loads(RECORD.read_text())
    ocd = OpenOCD()
    try:
        ocd.command("halt")
        check_identity(ocd, session)
        words = ocd.read(MAILBOX, MAILBOX_WORDS)
        h = unpack_header(words)
        validate_header(h)
        assert h["state"] == DONE and h["error"] == 0
        assert h["counts"] == [[100, 100, 100], [100, 100, 100]]
        assert h["fingerprint"] == session["host_oracle"]["fingerprint"]
        (LOGS / "mailbox.bin").write_bytes(struct.pack("<" + "I" * len(words), *words))
        results = {"recorded_utc": utc(), "source_commit": COMMIT, "header": h,
            "collection_note": "All API calls finished before halt. WFI caused zero-valued running-target SRAM reads; completed data recovered after halt without rerunning any measurement.",
            "measurements": []}
        for d in range(2):
            ops = {}
            for op, name in enumerate(["keygen", "sign", "verify"]):
                offset = HEADER_WORDS + (d * 3 + op) * 100
                cycles = words[offset:offset + 100]
                assert len(cycles) == 100 and min(cycles) > 0
                ops[name] = {"count": 100, "mean": statistics.mean(cycles), "median": statistics.median(cycles),
                    "stdev": statistics.stdev(cycles), "min": min(cycles), "max": max(cycles), "cycles": cycles}
            results["measurements"].append({"degree": 512 << d, "operations": ops})
        save_json(ROOT / "results.json", results)
        session["collection_note"] = results["collection_note"]
        save_json(RECORD, session)
        log(results["collection_note"])
        log("All 600 recorded timings and both final host fingerprints validated after completion; no measurement rerun.")
        restore(ocd, session)
        status = {"phase": "측정·검증·Flash 복원 완료 (종료 후 데이터 읽기 복구)", "updated_utc": utc(), "header": h}
        save_json(STATUS, status)
        write_report(status, session, results)
    finally:
        ocd.close()

def exclusive(action):
    # An advisory OS lock is released even if a controller crashes. A second
    # run or recovery must not halt/erase a board while the first is measuring.
    with (ROOT / ".controller.lock").open("a") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            raise RuntimeError("Another controller is active; refusing concurrent board access")
        action()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=["prepare", "run", "launch", "status", "recover", "finalize-completed"])
    args = parser.parse_args()
    if args.action == "prepare": exclusive(prepare)
    elif args.action == "run": exclusive(run)
    elif args.action == "recover": exclusive(recover)
    elif args.action == "finalize-completed": exclusive(finalize_completed)
    elif args.action == "launch": launch()
    elif STATUS.exists(): print(STATUS.read_text())
    else: print("No status recorded")
