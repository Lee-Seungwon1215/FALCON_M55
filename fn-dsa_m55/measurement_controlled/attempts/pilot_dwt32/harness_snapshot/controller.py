#!/usr/bin/env python3
"""Gated, explicit-device SRAM-only controlled benchmark; no Flash writer.

Each board owns an independent session, build/log directory and OpenOCD server.
The common harness and per-board build artifacts are frozen in the manifest.
"""
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
import time

ROOT = Path(__file__).resolve().parent
WORK = ROOT.parent
COMMIT = "a5f15894bf1a68017074650d5298cecf9bb29a79"
READY, RUNNING, DONE, FAILED, GO = 0x52454144, 0x52554E21, 0x600D0000, 0xBAD00000, 0x474F3130
HEADER_WORDS, WORDS = 92, 692
TARGETS = {
    "m4": dict(serial="066DFF363355473043205442", cpuid=0x410FC241,
        load=0x20000400, execute=0x400, size=191*1024, stack=0x200A0000,
        ram=0x20040000, ram_size=384*1024, mailbox=0x20030000, vtor=0x20000400,
        port=6668, openocd="/Users/seungwon/test/.tools/xpack-openocd-0.12.0-7/bin/openocd"),
    "m55": dict(serial="003C00223335510735383531", cpuid=0x411FD221,
        load=0x34180400, execute=0x34180400, size=255*1024, stack=0x341FF000,
        ram=0x341C0000, ram_size=252*1024, mailbox=0x341FF000, vtor=0x34180400,
        port=6669, openocd="/private/tmp/falcon-openocd/bin/openocd"),
}
def utc(): return datetime.datetime.now(datetime.timezone.utc).isoformat()
def sha(data): return hashlib.sha256(data).hexdigest()
def save(path, value):
    temp = path.with_name(path.name + ".tmp")
    temp.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n")
    temp.replace(path)
def parse_header(w):
    names = ["magic", "version", "state", "error", "runs", "degree", "iteration", "operation",
        "cpuid", "core_clock_hz", "hclk_hz", "cache_control", "vtor", "primask", "assembly",
        "m55_compat", "gcc_version", "mve_compiled", "mvfr0", "mvfr1", "mvfr2", "cpacr", "fpscr", "mpu_ctrl"]
    h = dict(zip(names, w[:24]))
    h.update(counts=[w[24:27], w[27:30]], warmup_fingerprint=w[30:32], fingerprint=w[32:34],
        command=w[34], fault_registers=w[35:40], device_id=w[40], flash_acr=w[41],
        pclk1_hz=w[42], pclk2_hz=w[43], pclk4_hz=w[44], pclk5_hz=w[45],
        clock_registers=w[46:58], mem_remap=w[58], dwt_control=w[59],
        output_digest=[w[60:68], w[68:76]], warmup_digest=[w[76:84], w[84:92]])
    return h
def validate(h, board):
    t = TARGETS[board]
    assert h["magic"] == 0x46434D50 and h["version"] == 1 and h["runs"] == 100
    assert h["cpuid"] == t["cpuid"] and h["vtor"] == t["vtor"]
    for k in ["core_clock_hz", "hclk_hz", "pclk1_hz", "pclk2_hz"]:
        assert h[k] == 24000000, (k, h[k])
    assert h["assembly"] == 1 and h["m55_compat"] == (board == "m55")
    assert h["gcc_version"] == 130201 and h["mve_compiled"] == 0
    assert h["primask"] == 1 and h["dwt_control"] & 1
    assert h["error"] == 0, h
    if board == "m4":
        assert h["flash_acr"] & 0x70F == 1 and h["mem_remap"] & 7 == 3
        assert h["device_id"] & 0xFFF == 0x470 and h["mpu_ctrl"] == 0
    else:
        assert h["cache_control"] & 0x30000 == 0 and h["mpu_ctrl"] & 5 == 5
        assert h["pclk4_hz"] == 24000000 and h["pclk5_hz"] == 24000000
        # Each IC divider is encoded as divider - 1 in bits [23:16].
        for value in h["clock_registers"][2:6]:
            assert ((value >> 16) & 255) == 49, hex(value)

class Controller:
    def __init__(self, board):
        self.board, self.t = board, TARGETS[board]
        self.out = WORK / ("fn-dsa_" + board) / "measurement_controlled"
        self.logs = self.out / "logs"; self.logs.mkdir(parents=True, exist_ok=True)
        self.build = self.out / "build"
        self.sock = self.server = None
        self.loaded = False
    def log(self, message):
        line = utc() + " " + str(message)
        print(line, flush=True)
        with (self.logs / "events.log").open("a") as f: f.write(line + "\n")
    def command(self, cmd, quiet=False):
        assert not any(x in cmd.lower() for x in ["flash ", "program ", "mass_erase", " option_write"])
        if not quiet: self.log("OpenOCD: " + cmd)
        packet = ('set _cmp_rc [catch {' + cmd + '} _cmp_msg]; '
            'format "%d:%s" $_cmp_rc $_cmp_msg\x1a')
        self.sock.sendall(packet.encode()); data = bytearray()
        while b"\x1a" not in data:
            chunk = self.sock.recv(65536)
            if not chunk: raise RuntimeError("OpenOCD disconnected")
            data.extend(chunk)
        code, result = bytes(data).split(b"\x1a", 1)[0].decode().split(":", 1)
        if code != "0": raise RuntimeError(cmd + ": " + result)
        if result and not quiet: self.log(result)
        return result
    def read(self, addr, n):
        values = [int(x, 0) for x in self.command(f"read_memory 0x{addr:08x} 32 {n}", True).split()]
        assert len(values) == n
        return values
    def header(self): return parse_header(self.read(self.t["mailbox"], HEADER_WORDS))
    def start_server(self):
        # Never connect to or shut down a pre-existing server.
        try:
            s = socket.create_connection(("127.0.0.1", self.t["port"]), timeout=1)
        except OSError: pass
        else:
            s.close(); raise RuntimeError("Dedicated port is already occupied")
        self.server_log = (self.logs / "openocd.log").open("a")
        self.server = subprocess.Popen([self.t["openocd"], "-f", str(ROOT / ("openocd_" + self.board + ".cfg"))],
            stdout=self.server_log, stderr=subprocess.STDOUT, cwd=ROOT)
        for _ in range(100):
            if self.server.poll() is not None: raise RuntimeError("OpenOCD startup failed; inspect openocd.log")
            try: self.sock = socket.create_connection(("127.0.0.1", self.t["port"]), timeout=1); break
            except OSError: time.sleep(0.2)
        if self.sock is None: raise RuntimeError("OpenOCD startup timeout")
        # Full 2 MiB read-only Flash preservation check takes ~33 s at 1 MHz SWD.
        self.sock.settimeout(240)
    def source_audit(self):
        ref = WORK / ("fn-dsa_" + self.board) / "ref"
        def git(*args): return subprocess.check_output(["git", *args], cwd=ref)
        assert git("rev-parse", "HEAD").decode().strip() == COMMIT
        changed = git("diff", "HEAD", "--name-only").decode().splitlines()
        assert changed == (["inner.h"] if self.board == "m55" else []), changed
        hashes = {}
        for p in sorted(ref.iterdir()):
            if p.suffix not in [".c", ".h", ".s"]: continue
            data = p.read_bytes(); hashes[p.name] = sha(data)
            if not (self.board == "m55" and p.name == "inner.h"):
                assert data == git("show", "HEAD:" + p.name), p.name
        (self.logs / "source.patch").write_bytes(git("diff", "HEAD"))
        return hashes
    def firmware_audit(self):
        raw = (self.build / "firmware.bin").read_bytes()
        assert 0 < len(raw) <= self.t["size"]
        sp, entry = struct.unpack_from("<II", raw)
        assert sp == self.t["stack"] and entry & 1
        assert self.t["execute"] <= (entry & ~1) < self.t["execute"] + len(raw)
        syms = {}
        for line in (self.build / "symbols.txt").read_text().splitlines():
            a = line.split()
            if len(a) == 3: syms[a[2]] = int(a[0], 16)
        assert syms["bench_results"] == self.t["mailbox"]
        assert syms["_ebss"] <= syms["_sstack"] and syms["_estack"] == sp
        for n in ["main", "fndsa_keygen_seeded_temp", "fndsa_sign_seeded_temp", "fndsa_verify_temp"]:
            assert self.t["execute"] <= syms[n] < self.t["execute"] + len(raw), n
        for n in ["sk", "pk", "sig", "tmp"]: assert syms[n] % 32 == 0, n
        # Parse ELF32 little-endian PT_LOAD program headers, not just vector words.
        elf = (self.build / "firmware.elf").read_bytes()
        assert elf[:6] == b"\x7fELF\x01\x01"
        phoff, = struct.unpack_from("<I", elf, 28)
        phentsize, phnum = struct.unpack_from("<HH", elf, 42)
        ranges = [(self.t["execute"], self.t["size"]), (self.t["ram"], self.t["ram_size"]), (self.t["mailbox"], 4096)]
        for i in range(phnum):
            typ, off, va, pa, fs, ms, flags, align = struct.unpack_from("<8I", elf, phoff + i * phentsize)
            if typ != 1: continue
            assert any(start <= va and va + ms <= start + length for start, length in ranges), (va, ms)
            if fs: assert self.t["execute"] <= pa and pa + fs <= self.t["execute"] + len(raw), (pa, fs)
        return sp, entry, {"binary_sha256": sha(raw), "elf_sha256": sha(elf), "binary_bytes": len(raw), "symbols": syms}
    def update(self, phase, session, h=None, **extra):
        state = dict(phase=phase, updated_utc=utc(), **extra)
        if h is not None: state["header"] = h
        save(self.out / "status.json", state); save(self.out / "session.json", session)
        self.report(state, session)
    def report(self, status, session, results=None):
        h = status.get("header", {})
        lines = [f"# FN-DSA {self.board.upper()}: SRAM / cache OFF / CPU·HCLK 24 MHz", "",
            f"상태: **{status['phase']}** ({status['updated_utc']}).", "",
            "기존 측정 결과는 변경하지 않고 보존한다. 최신 공개 M4 구현의 플랫폼 비교이며 논문 당시 실험의 완전 재현이나 순수 코어 성능 비교가 아니다.", "",
            "## 공통 조건", "",
            f"- 고정 소스 `{COMMIT}`, GCC 13.2.1 / `-O3 -ffp-contract=off`, LTO·fast-math 없음.",
            "- M4 정수/DSP 어셈블리 ON, native FP64 전환·MVE 없음. CPU/ABI/보드 초기화 차이는 빌드 로그에 기록.",
            "- CPU/HCLK/PCLK1/PCLK2 공칭 24 MHz. M55의 IC1/2/6/11 및 PCLK4/5도 24 MHz. M4 MSI vs M55 HSI→PLL1 발진원 차이는 남는다.",
            "- 두 보드 코드·상수·데이터·스택 모두 내부 SRAM, 캐시 OFF. DMA는 벤치마크에서 사용하지 않는다.",
            "- M4: SRAM1 physical 0x20000400에 로드하고 0x00000400 alias로 실행(ICode/DCode). SRAM3 데이터·스택, SRAM2 mailbox. Flash cache/prefetch OFF, Flash 1WS 설정은 남지만 실행·상수 읽기에 Flash를 사용하지 않는다.",
            "- M55: AXISRAM2 0x34180400 코드, 0x341C0000 데이터, 0x341FF000 stack top/mailbox. I/D cache OFF, 해당 SRAM 전체 MPU Normal non-cacheable. AXI 경로이며 M4와 물리 구조는 같지 않다.",
            "- 32-byte 정렬 버퍼, FN-DSA-512/1024 키 생성·서명·검증 각 100회, 크기별 워밍업 각 1회 제외.",
            "- 이전과 동일한 결정적 32-byte key seed / 40-byte sign seed, RAW 메시지 `blah` 4 bytes, 빈 context.",
            "- DWT 32-bit cycle 차분으로 seeded/temp API 전체 측정. 내부 재시도 포함; 시드 준비·출력 해시·로그 제외. PRIMASK=1, SysTick OFF.",
            "- 약 60초 간격으로 코어를 정지하지 않고 mailbox 읽기. 디버그 버스 영향이 엄밀히 0이라는 보장은 없다.",
            "- 출력 전체(sk || pk || signature)의 누적 SHAKE256 32-byte digest 및 기존 FNV 진단값을 호스트와 대조. 워밍업에서 변조 서명 거부 확인. constant-time/부채널 안전성 검증과는 별개.", "",
            "## 설정 검증 및 진행", "", "```json", json.dumps(h, indent=2), "```", ""]
        if session.get("clock_probe"):
            lines += ["클럭 교차 확인(READY 상태, 본 계측 전): `" + json.dumps(session["clock_probe"]) + "`. 호스트 시간 대조이며 외부 정밀 계측기로 보정한 값은 아니다.", ""]
        if status.get("error"): lines += ["오류: " + status["error"], ""]
        if results is None and (self.out / "results.json").exists(): results = json.loads((self.out / "results.json").read_text())
        if results:
            lines += ["## 결과", "", "| 크기 | 연산 | n | 평균 cycles | 중앙값 | 표준편차 | 최소 | 최대 | 평균 ms |", "|---|---|---:|---:|---:|---:|---:|---:|---:|"]
            for d in results["measurements"]:
                for op, s in d["operations"].items():
                    lines.append(f"| {d['degree']} | {op} | 100 | {s['mean']:,.2f} | {s['median']:,.1f} | {s['stdev']:,.2f} | {s['min']:,} | {s['max']:,} | {s['mean']/24000:.3f} |")
            lines += ["", "표본 표준편차. 이상치 제외 없음. ms는 공칭 24 MHz 환산.", "",
                "```csv", "degree,index,keygen_cycles,sign_cycles,verify_cycles"]
            for d in results["measurements"]:
                for i in range(100): lines.append(",".join(map(str, [d["degree"], i+1] + [d["operations"][op]["cycles"][i] for op in ["keygen", "sign", "verify"]])))
            lines += ["```", "", "32-bit cycle wrap audit: `" + json.dumps(results["wrap_audit"]) + "`.", ""]
        lines += ["## 로그·재현", "",
            "- [공통 코드·조건](../../comparison_m4_m55/README.md), [컨트롤러](../../comparison_m4_m55/controller.py).",
            "- [메타데이터·SHA-256](session.json), [진행 상태](status.json), [원시 결과](results.json).",
            "- [빌드 로그](build.log), [OpenOCD 로그](logs/openocd.log), [원시 mailbox](logs/mailbox.bin).",
            "- [소스 패치](logs/source.patch), ELF·디스어셈블리·심볼·메모리 배치: `build/`.",
            "- 측정 펌웨어 로드는 SRAM에만 수행. Flash·option bytes 기록/삭제 없음. 종료 후 해당 MCU halt 및 이 세션의 OpenOCD 종료.", "",
            "### 실행 로그", "", "```text", (self.logs / "events.log").read_text() if (self.logs / "events.log").exists() else "", "```", ""]
        (self.out / "result.md").write_text("\n".join(lines))
    def run(self):
        assert not (self.out / "session.json").exists(), "Existing session must be preserved"
        source = self.source_audit(); sp, entry, firmware = self.firmware_audit()
        oracle = json.loads((ROOT / "build/host_oracle.json").read_text())
        old = json.loads((WORK / "fn-dsa_m4/measurement/build/host_oracle.json").read_text())
        for k in ["warmup_fingerprint", "fingerprint"]: assert oracle[k] == old[k]
        session = dict(created_utc=utc(), board=self.board, target=self.t, source_commit=COMMIT,
            source_hashes=source, firmware=firmware, host_oracle=oracle,
            harness_hashes={p.name: sha(p.read_bytes()) for p in ROOT.iterdir() if p.suffix in [".c", ".h", ".ld", ".py", ".cfg"] or p.name == "Makefile"})
        self.update("빌드 검증 완료 / 보드 연결 준비", session)
        try:
            self.start_server()
            self.command("halt")
            assert self.read(0xE000ED00, 1)[0] == self.t["cpuid"]
            if self.board == "m4":
                ident = dict(device_id=self.read(0xE0042000, 1)[0], uid=self.read(0x1FFF7590, 3),
                    flash_kib=self.read(0x1FFF75E0, 1)[0] & 0xFFFF, optr=self.read(0x40022020, 1)[0])
                previous = json.loads((WORK / "fn-dsa_m4/measurement/session.json").read_text())["identity"]
                assert ident["device_id"] == previous["device_id"] and ident["uid"] == previous["uid"]
                assert ident["flash_kib"] == 2048 and ident["optr"] & 255 == 0xAA
                session["identity"] = ident
                self.command(f"dump_image {{{self.logs / 'flash_before.bin'}}} 0x08000000 0x200000")
                session["flash_before_sha256"] = sha((self.logs / "flash_before.bin").read_bytes())
            self.command("reset halt")
            binary = self.build / "firmware.bin"
            self.loaded = True
            self.command(f"load_image {{{binary}}} 0x{self.t['load']:08x} bin")
            self.command(f"verify_image {{{binary}}} 0x{self.t['load']:08x} bin")
            if self.board == "m4":
                en = self.read(0x40021060, 1)[0] | 1
                self.command(f"write_memory 0x40021060 32 {{0x{en:08x}}}")
                remap = (self.read(0x40010000, 1)[0] & ~7) | 3
                self.command(f"write_memory 0x40010000 32 {{0x{remap:08x}}}")
                self.command(f"verify_image {{{binary}}} 0x00000400 bin")
            for reg, value in [("sp", sp), ("msp", sp), ("psp", sp), ("xpsr", 0x01000000),
                ("primask", 0), ("basepri", 0), ("faultmask", 0), ("control", 0)]:
                self.command(f"reg {reg} 0x{value:08x}")
            self.command(f"resume 0x{entry & ~1:08x}")
            self.update("SRAM 실행 / 워밍업·설정 검증 중", session)
            start = time.monotonic()
            while time.monotonic() - start < 300:
                time.sleep(2); h = self.header()
                if h["state"] == FAILED: raise RuntimeError("warmup failure: " + json.dumps(h))
                if h["state"] == READY: break
            assert h["state"] == READY, h
            validate(h, self.board)
            for k in ["warmup_fingerprint", "warmup_digest"]: assert h[k] == oracle[k], (k, h[k])
            # An independent wall-time sanity check guards against merely printing 24 MHz.
            a = time.monotonic(); c0 = self.read(0xE0001004, 1)[0]; b = time.monotonic()
            time.sleep(3)
            c = time.monotonic(); c1 = self.read(0xE0001004, 1)[0]; d = time.monotonic()
            duration = (c+d-a-b)/2
            frequency = ((c1-c0) & 0xFFFFFFFF) / duration
            assert 23000000 < frequency < 25000000, frequency
            session["clock_probe"] = dict(elapsed_seconds=duration, observed_cycles=(c1-c0)&0xFFFFFFFF,
                inferred_hz=frequency, read_time_uncertainty_seconds=(b-a+d-c)/2)
            session["warmup_verified"] = True
            session["started_utc"] = utc()
            self.log("READY: both warmups, output SHAKE256 digests, tampered-signature rejection, clocks and cache settings passed.")
            self.log("clock probe: " + json.dumps(session["clock_probe"]))
            assert self.source_audit() == source, "source changed before GO"
            began = time.monotonic()
            self.command(f"write_memory 0x{self.t['mailbox']+34*4:08x} 32 {{0x{GO:08x}}}")
            while True:
                h = self.header(); validate(h, self.board)
                self.log(f"counts={h['counts']} degree={h['degree']} index={h['iteration']} op={h['operation']} state=0x{h['state']:08x}")
                self.update("동일 조건 100회 본 측정 중", session, h, elapsed_seconds=round(time.monotonic()-began, 2))
                if h["state"] in [DONE, FAILED]: break
                if time.monotonic()-began > 7200: raise RuntimeError("2-hour observation limit exceeded")
                time.sleep(60)
            observed = time.monotonic()-began
            self.command("halt")
            words = self.read(self.t["mailbox"], WORDS)
            (self.logs / "mailbox.bin").write_bytes(struct.pack("<"+"I"*WORDS, *words))
            h = parse_header(words); validate(h, self.board)
            assert h["state"] == DONE and h["counts"] == [[100]*3, [100]*3]
            for k in ["fingerprint", "output_digest"]: assert h[k] == oracle[k], k
            results = dict(recorded_utc=utc(), header=h, measurements=[])
            total = 0
            for degree in range(2):
                ops = {}
                for op, name in enumerate(["keygen", "sign", "verify"]):
                    offset = HEADER_WORDS + (degree*3+op)*100
                    cycles = words[offset:offset+100]; assert min(cycles) > 0
                    total += sum(cycles)
                    ops[name] = dict(count=100, mean=statistics.mean(cycles), median=statistics.median(cycles),
                        stdev=statistics.stdev(cycles), min=min(cycles), max=max(cycles), cycles=cycles)
                results["measurements"].append(dict(degree=512 << degree, operations=ops))
            # Under the checked nominal clock, even one omitted full cycle wrap
            # must not fit within the observed total time (including polling delay).
            wrap_s = 2**32/24000000
            residual = observed-total/24000000
            audit = dict(observed_seconds=observed, timed_api_seconds=total/24000000,
                unaccounted_seconds=residual, one_wrap_seconds=wrap_s,
                passed=-observed*0.02 <= residual and residual + observed*0.02 < wrap_s,
                assumption="nominal clock within 2%; includes host polling and hash/log overhead")
            results["wrap_audit"] = audit
            assert audit["passed"], audit
            assert self.source_audit() == source, "Source changed during run; artifacts are preserved"
            if self.board == "m4":
                self.command(f"verify_image {{{self.logs / 'flash_before.bin'}}} 0x08000000 bin")
                assert self.read(0x40022020, 1)[0] == session["identity"]["optr"]
                session["flash_unchanged_verified"] = True
            save(self.out / "results.json", results)
            self.log("DONE: 600 samples validated; output digests match host; SRAM-only experiment complete.")
            session["finished_utc"] = utc(); session["observed_seconds"] = observed
            self.update("100회 측정·출력 대조·설정 검증 완료", session, h)
        except Exception as exc:
            self.log("ERROR " + repr(exc))
            self.update("오류로 중단 / 최종 결과 미확정", session, error=repr(exc))
            raise
        finally:
            if self.sock:
                try:
                    if self.loaded: self.command("halt")
                    self.command("shutdown")
                except Exception as exc: self.log("cleanup: " + repr(exc))
                self.sock.close()
            if self.server:
                try: self.server.wait(timeout=10)
                except subprocess.TimeoutExpired:
                    self.server.terminate(); self.server.wait(timeout=10)
                self.server_log.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(); parser.add_argument("board", choices=TARGETS)
    args = parser.parse_args()
    ctl = Controller(args.board)
    with (ctl.out / ".controller.lock").open("w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        ctl.run()
