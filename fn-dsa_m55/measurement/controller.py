#!/usr/bin/env python3
"""M55 SRAM-only benchmark: explicit device, gated correctness, timed API calls."""
import argparse
import datetime
import fcntl
import hashlib
import json
from pathlib import Path
import socket
import statistics
import struct
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parent
REF, BUILD, LOGS = ROOT.parent / "ref", ROOT / "build", ROOT / "logs"
REPORT = ROOT.parent / "result.md"
COMMIT = "a5f15894bf1a68017074650d5298cecf9bb29a79"
SERIAL = "003C00223335510735383531"
RAM_BASE, ROM_SIZE, MAILBOX = 0x34180400, 255 * 1024, 0x341FF000
HEADER_WORDS, WORDS = 40, 640
READY, RUNNING, DONE, FAILED, GO = 0x52454144, 0x52554E21, 0x600D0000, 0xBAD00000, 0x474F3130
ORACLE = ROOT.parent.parent / "fn-dsa_m4/measurement/build/host_oracle.json"

def utc(): return datetime.datetime.now(datetime.timezone.utc).isoformat()
def sha(data): return hashlib.sha256(data).hexdigest()
def save(path, value):
    temp = path.with_name(path.name + ".tmp")
    temp.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n")
    temp.replace(path)
def log(message):
    LOGS.mkdir(exist_ok=True)
    line = utc() + " " + str(message)
    print(line, flush=True)
    with (LOGS / "events.log").open("a") as out: out.write(line + "\n")

class OpenOCD:
    def __init__(self):
        self.sock = socket.create_connection(("127.0.0.1", 6667), timeout=10)
        self.sock.settimeout(90)
    def command(self, command, quiet=False):
        # There is intentionally no Flash programming/recovery operation here.
        assert not any(x in command.lower() for x in ["flash ", "program ", "mass_erase"])
        if not quiet: log("OpenOCD: " + command)
        packet = ('set _m55_rc [catch {' + command + '} _m55_msg]; '
            'format "%d:%s" $_m55_rc $_m55_msg\x1a')
        self.sock.sendall(packet.encode())
        data = bytearray()
        while b"\x1a" not in data:
            block = self.sock.recv(65536)
            if not block: raise RuntimeError("OpenOCD disconnected")
            data.extend(block)
        code, result = bytes(data).split(b"\x1a", 1)[0].decode().split(":", 1)
        if code != "0": raise RuntimeError(command + ": " + result)
        if result and not quiet: log(result)
        return result
    def read(self, address, count):
        result = [int(x, 0) for x in self.command(f"read_memory 0x{address:08x} 32 {count}", True).split()]
        assert len(result) == count
        return result
    def close(self): self.sock.close()

def header(words):
    names = ["magic", "version", "state", "error", "runs", "degree", "iteration", "operation",
        "cpuid", "core_clock_hz", "hclk_hz", "cache_control", "vtor", "primask", "assembly",
        "m55_compat", "gcc_version", "mve_compiled", "mvfr0", "mvfr1", "mvfr2", "cpacr", "fpscr", "mpu_ctrl"]
    h = dict(zip(names, words[:24]))
    h.update(counts=[words[24:27], words[27:30]], warmup_fingerprint=words[30:32],
        fingerprint=words[32:34], command=words[34], fault_registers=words[35:40])
    return h

def validate(h):
    assert h["magic"] == 0x464D3550 and h["version"] == 1 and h["runs"] == 100
    assert h["cpuid"] == 0x411FD221 and h["core_clock_hz"] == 600000000
    assert h["hclk_hz"] == 200000000 and h["cache_control"] & 0x30000 == 0x30000
    assert h["vtor"] == RAM_BASE and h["primask"] == 1
    assert h["assembly"] == 1 and h["m55_compat"] == 1
    assert h["gcc_version"] == 130201 and h["mve_compiled"] == 0
    assert h["mpu_ctrl"] & 5 == 5

def symbol(name):
    for line in (BUILD / "symbols.txt").read_text().splitlines():
        parts = line.split()
        if len(parts) == 3 and parts[2] == name: return int(parts[0], 16)
    raise RuntimeError("Missing symbol " + name)

def source_audit():
    head = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=REF, text=True).strip()
    changed = subprocess.check_output(["git", "diff", "HEAD", "--name-only"], cwd=REF, text=True).splitlines()
    assert head == COMMIT and changed == ["inner.h"], (head, changed)
    hashes = {}
    for p in sorted(REF.iterdir()):
        if p.suffix not in [".c", ".h", ".s"]: continue
        data = p.read_bytes()
        hashes[p.name] = sha(data)
        if p.name != "inner.h":
            original = subprocess.check_output(["git", "show", "HEAD:" + p.name], cwd=REF)
            assert data == original, "Unexpected arithmetic source change: " + p.name
    patch = subprocess.check_output(["git", "diff", "HEAD", "--", "inner.h"], cwd=REF, text=True)
    (LOGS / "port.patch").write_text(patch)
    return hashes

def report(status, session, results=None):
    h = status.get("header", {})
    lines = ["# FN-DSA: M4 어셈블리 유지 / Cortex-M55 실측", "",
        f"상태: **{status['phase']}**. 갱신: `{status['updated_utc']}`.", "",
        "이 실험은 `fn-dsa_m55/ref`의 M4 정수/DSP 어셈블리를 M55에 이식한 기준 구현이다. 하드웨어 FP64 또는 MVE로 재작성한 최적화 버전이 아니다.", "",
        "## 측정 조건", "", "| 항목 | 설정 |", "|---|---|",
        f"| 원본 | `pornin/c-fn-dsa`, `{COMMIT}` |",
        "| 실제 사용 경로 | `fn-dsa_m55/ref`; 복사되어 있던 `ref/profiling`의 과거 결과·생성본은 사용하지 않음 |",
        "| 소스 변경 | `ref/inner.h`의 명시적 M55 어셈블리 호환 선택·검사만 추가. 원본 C 연산과 5개 `.s` 내용은 동일 |",
        "| 어셈블리 | `FNDSA_ASM_CORTEXM4=1`, `FNDSA_ASM_CORTEXM55=1`; codec/mq/sha3/sign_fpr/sign_sampler의 `.s` 및 인라인 ASM 유지 |",
        "| 컴파일러 | Arm GNU 13.2.Rel1 / GCC 13.2.1 |",
        "| 빌드 | `-O3 -mthumb -mcpu=cortex-m55+nomve -mfpu=auto -mfloat-abi=hard -mcmse`; LTO/fast-math 없음 |",
        "| MVE | 이번 기준 측정에서는 명령 생성을 비활성화. C fallback으로 바꾸는 것이 아님 |",
        "| 수 표현 | 키 생성 32.32 고정소수점, 서명 binary64 비트열의 정수 에뮬레이션. FP 레지스터는 기존 ASM의 임시 저장에 사용 |",
        f"| 보드 | NUCLEO-N657X0-Q / STM32N657, CPUID 0x411fd221, ST-LINK `{SERIAL}` |",
        "| 클럭 | CPU 공칭 600 MHz, HCLK 200 MHz, HSI→PLL1. 기존 M55 프로파일링과 같은 클럭 설정 |",
        "| 코드·상수 | AXI SRAM2 `0x34180400`부터. 외부 Flash 기록·삭제 없음 |",
        "| 데이터·스택 | AXI SRAM2 `0x341C0000`부터; 스택 최상단 `0x341FF000`, 스택 최소 여유 96 KiB |",
        "| 캐시·진행 상태 | I/D cache ON; 결과 mailbox `0x341FF000..0x341FFFFF`만 MPU로 Normal non-cacheable 설정 |",
        "| 반복 | FN-DSA-512/1024 각각 키 생성·서명·검증 100회. 크기별 워밍업 각 1회 제외 |",
        "| 입력 | M4 측정과 같은 결정적 키 시드 32 B, 서명 시드 40 B. 매회 새 키→서명→검증. 메시지 `blah` 4 B, RAW, 빈 context |",
        "| 계측 | DWT CYCCNT로 seeded/temp API 전체. 내부 재시도 포함, 외부 RNG·시드 준비·체크섬·로그 제외 |",
        "| 인터럽트 | 본 계측 중 PRIMASK=1, SysTick OFF |",
        "| 모니터링 | 약 60초마다 non-cacheable mailbox 헤더 160 B 읽기. 본 측정 중 halt/reset 없음 |", "",
        "M4 측정은 24 MHz·Flash 1 WS·캐시 OFF·다른 SRAM 배치였으므로, 사이클 또는 시간 차이를 CPU 코어 하나의 효과로 해석하면 안 된다.", "",
        "DWT 차분은 32비트다. API 한 번이 2^32 cycles(600 MHz에서 약 7.16초) 미만이라는 전제가 있고, 다중 wrap 검출 인터럽트는 넣지 않았다. ms는 공칭 클럭 환산이다.", "",
        "디버그 버스 상태 읽기의 성능 영향이 정확히 0임을 검증한 실험은 아니다. 본 결과는 기능·성능 검증이며 별도의 constant-time/부채널 안전성 감사 결과가 아니다.", "",
        "## 정확성 및 진행", ""]
    if h:
        lines += [f"- 크기 {h['degree']}, 0-based index {h['iteration']}, 단계 {['keygen','sign','verify'][min(h['operation'],2)]}.",
            f"- 완료 [키 생성, 서명, 검증]: 512 `{h['counts'][0]}`, 1024 `{h['counts'][1]}`.",
            f"- 상태 `0x{h['state']:08x}`, 오류 `0x{h['error']:08x}`.",
            f"- CPU/HCLK={h['core_clock_hz']}/{h['hclk_hz']}, CCR=`0x{h['cache_control']:08x}`, MPU_CTRL=`0x{h['mpu_ctrl']:08x}`.",
            f"- 실제 FPU feature: MVFR0=`0x{h['mvfr0']:08x}`, MVFR1=`0x{h['mvfr1']:08x}`, MVFR2=`0x{h['mvfr2']:08x}`."]
    lines += [f"- 워밍업 호스트 대조: {session.get('warmup_verified', False)}. 정상 서명 검증과 변조 서명 거부를 포함한다.",
        "- 기준값은 동일 입력 100회씩을 실행한 portable C 호스트 결과다. M4와 동일한 입력·FNV-1a 진단 체크섬을 사용한다.",
        "- 체크섬 일치는 진단용이며 암호학적 동등성 증명은 아니다. 결정적 시드는 실서비스 키 생성용이 아니다.", ""]
    if status.get("error"): lines += ["오류: `" + status["error"] + "`", ""]
    if results:
        lines += ["## 최종 결과", "", "100회 전체를 집계했다. 표준편차는 표본 표준편차이며 이상치를 제외하지 않았다.", "",
            "| 크기 | 단계 | 횟수 | 평균 cycles | 중앙값 | 표준편차 | 최소 | 최대 | 평균 ms |",
            "|---|---|---:|---:|---:|---:|---:|---:|---:|"]
        for item in results["measurements"]:
            for name, data in item["operations"].items():
                lines.append(f"| {item['degree']} | {name} | {data['count']} | {data['mean']:,.2f} | {data['median']:,.1f} | {data['stdev']:,.2f} | {data['min']:,} | {data['max']:,} | {data['mean']/600000:.3f} |")
        lines += ["", "### 회차별 원시 사이클", "", "```csv", "degree,index,keygen_cycles,sign_cycles,verify_cycles"]
        for item in results["measurements"]:
            for i in range(100):
                values = [item["operations"][n]["cycles"][i] for n in ["keygen", "sign", "verify"]]
                lines.append(",".join(map(str, [item["degree"], i+1] + values)))
        lines += ["```", ""]
    else: lines += ["## 최종 결과", "", "아직 확정된 결과가 없다.", ""]
    lines += ["## 파일·재현", "",
        "- [빌드 방법·변경 범위](measurement/README.md), [실제 빌드 설정](measurement/Makefile).",
        "- [메타데이터·소스 SHA-256](measurement/session.json), [상태](measurement/status.json), [원시 결과](measurement/results.json).",
        "- [실행 로그](measurement/logs/events.log), [빌드 로그](measurement/logs/build.log), [이식 패치](measurement/logs/port.patch).",
        "- [산출물·통계·어셈블리 대조 검증](measurement/logs/artifact_audit.log), [검증 스크립트](measurement/verify_artifacts.py).",
        "- ELF·bin·디스어셈블리·ELF 속성은 `measurement/build`에 보존한다.",
        "- 종료 후 MCU는 halt 상태로 둔다. 측정 RAM은 남으며 원래 실행 중 RAM 상태를 복원한 것은 아니다. Flash는 처음부터 쓰지 않는다.", ""]
    for title, file in [("소스 이식 패치", "port.patch"), ("빌드 로그", "build.log"), ("실행·검증 로그", "events.log"), ("산출물 사후 검증 로그", "artifact_audit.log")]:
        path = LOGS / file
        if path.exists(): lines += ["## " + title, "", "```text", path.read_text().rstrip(), "```", ""]
    temp = REPORT.with_name(REPORT.name + ".tmp")
    temp.write_text("\n".join(lines))
    temp.replace(REPORT)

def run():
    LOGS.mkdir(exist_ok=True)
    assert not (ROOT / "results.json").exists(), "Existing completed results must not be overwritten"
    session = {"created_utc": utc(), "source_commit": COMMIT, "stlink_serial": SERIAL,
        "source_hashes": source_audit(), "host_oracle": json.loads(ORACLE.read_text())}
    data = (BUILD / "fndsa_m55.bin").read_bytes()
    assert 0 < len(data) <= ROM_SIZE
    sp, entry = struct.unpack_from("<II", data)
    assert sp == MAILBOX and RAM_BASE <= entry < RAM_BASE + ROM_SIZE and entry & 1
    assert symbol("bench_results") == MAILBOX
    session.update(binary_sha256=sha(data), elf_sha256=sha((BUILD / "fndsa_m55.elf").read_bytes()),
        harness_hashes={p.name: sha(p.read_bytes()) for p in ROOT.iterdir()
            if p.suffix in [".c", ".h", ".ld", ".py", ".cfg"] or p.name == "Makefile"})
    save(ROOT / "session.json", session)
    ocd = OpenOCD()
    try:
        assert ocd.read(0xE000ED00, 1)[0] == 0x411FD221, "Unexpected processor"
        session["mvfr_before"] = ocd.read(0xE000EF40, 3)
        save(ROOT / "session.json", session)
        status = {"phase": "SRAM 로드 / 워밍업 검증 중", "updated_utc": utc()}
        save(ROOT / "status.json", status); report(status, session)
        ocd.command("reset halt")
        # Never call flash/program: write precisely this bounded SRAM image.
        binary = BUILD / "fndsa_m55.bin"
        ocd.command(f"load_image {{{binary}}} 0x{RAM_BASE:08x} bin")
        ocd.command(f"verify_image {{{binary}}} 0x{RAM_BASE:08x} bin")
        for name, value in [("sp", sp), ("msp", sp), ("psp", sp), ("xpsr", 0x01000000),
                ("primask", 0), ("basepri", 0), ("faultmask", 0), ("control", 0)]:
            ocd.command(f"reg {name} 0x{value:08x}")
        ocd.command(f"resume 0x{entry & ~1:08x}")
        began = time.monotonic()
        h = {}
        while time.monotonic() - began < 180:
            time.sleep(1)
            h = header(ocd.read(MAILBOX, HEADER_WORDS))
            if h["state"] == FAILED: raise RuntimeError("Warmup failure: " + json.dumps(h))
            if h["state"] == READY: break
        assert h.get("state") == READY, "Warmup did not reach ready state: " + json.dumps(h)
        validate(h)
        assert h["warmup_fingerprint"] == session["host_oracle"]["warmup_fingerprint"], "Warmup differs from host oracle"
        session["warmup_verified"] = True
        session["started_utc"] = utc()
        save(ROOT / "session.json", session)
        log("Both warmups, valid/tampered signature checks and host fingerprints passed.")
        ocd.command(f"write_memory 0x{MAILBOX + 34*4:08x} 32 {{0x{GO:08x}}}")
        began = time.monotonic()
        while True:
            h = header(ocd.read(MAILBOX, HEADER_WORDS))
            validate(h)
            status = {"phase": "100회 본 측정 진행 중", "updated_utc": utc(),
                "elapsed_seconds": round(time.monotonic()-began, 2), "header": h}
            log(f"progress counts={h['counts']}, degree={h['degree']}, operation={h['operation']}, error={h['error']}")
            save(ROOT / "status.json", status); report(status, session)
            if h["state"] in [DONE, FAILED]: break
            if time.monotonic() - began > 1800: raise RuntimeError("30-minute limit exceeded")
            time.sleep(60)
        ocd.command("halt")
        words = ocd.read(MAILBOX, WORDS)
        (LOGS / "mailbox.bin").write_bytes(struct.pack("<" + "I"*WORDS, *words))
        h = header(words)
        validate(h)
        assert h["state"] == DONE and h["error"] == 0
        assert h["counts"] == [[100,100,100], [100,100,100]]
        assert h["fingerprint"] == session["host_oracle"]["fingerprint"], "Final host fingerprints differ"
        results = {"recorded_utc": utc(), "header": h, "measurements": []}
        for d in range(2):
            ops = {}
            for op, name in enumerate(["keygen", "sign", "verify"]):
                offset = HEADER_WORDS + (d*3+op)*100
                cycles = words[offset:offset+100]
                assert len(cycles) == 100 and min(cycles) > 0
                ops[name] = {"count": 100, "mean": statistics.mean(cycles), "median": statistics.median(cycles),
                    "stdev": statistics.stdev(cycles), "min": min(cycles), "max": max(cycles), "cycles": cycles}
            results["measurements"].append({"degree": 512 << d, "operations": ops})
        save(ROOT / "results.json", results)
        log("All 600 measured operations passed; both final fingerprints match host. No Flash was written. M55 left halted.")
        status = {"phase": "100회 측정·정확성 검증 완료", "updated_utc": utc(), "header": h}
        save(ROOT / "status.json", status); report(status, session, results)
    except Exception as exc:
        log("ERROR: " + repr(exc))
        status = {"phase": "오류로 중단 / 결과 미확정", "updated_utc": utc(), "error": repr(exc)}
        try: ocd.command("halt")
        except Exception as halt_error: log("Cannot halt: " + repr(halt_error))
        save(ROOT / "status.json", status); report(status, session)
        raise
    finally: ocd.close()

def launch():
    LOGS.mkdir(exist_ok=True)
    with (LOGS / "background.log").open("a") as out:
        child = subprocess.Popen(["/usr/bin/caffeinate", "-i", sys.executable, str(__file__), "run"],
            cwd=ROOT, stdin=subprocess.DEVNULL, stdout=out, stderr=subprocess.STDOUT, start_new_session=True)
    save(ROOT / "background.json", {"pid": child.pid, "launched_utc": utc()})
    print("Launched M55 controller PID", child.pid)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=["run", "launch", "status"])
    args = parser.parse_args()
    if args.action == "status":
        print((ROOT / "status.json").read_text() if (ROOT / "status.json").exists() else "Not started")
    elif args.action == "launch": launch()
    else:
        with (ROOT / ".controller.lock").open("a") as lock:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            run()
