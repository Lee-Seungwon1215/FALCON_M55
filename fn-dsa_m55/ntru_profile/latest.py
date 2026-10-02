#!/usr/bin/env python3
"""Audit and report the current pre-Slothy NTRU FFT profile; keep old runs intact."""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
import shlex
import subprocess
import sys

sys.dont_write_bytecode = True
import instrument
from run import sha, tree_sha, validate

ROOT = Path(__file__).resolve().parent
WORK = ROOT.parent
SOURCE = WORK / "ntt_opt"
COMMON = WORK / "measurement_mlkem_native"
ASM = "codec_cm4 mq_cm55 sha3_cm4 sign_fpr_cm4 sign_sampler_cm4 kgen_mp31_cm55".split()
CANDIDATES = ("ntt_opt_control", "ntt_opt_fft")


def require(ok, message):
    if not ok:
        raise RuntimeError(message)


def inputs(candidate):
    build = ROOT / "build" / candidate
    mode = candidate.removeprefix("ntt_opt_")
    source_files = {p.name: sha(p) for p in sorted(SOURCE.iterdir())
                    if p.suffix in (".c", ".h", ".s")}
    recent = json.loads((WORK / "stage_profile_compare/results/ntt_opt/validated.json").read_text())
    require(tree_sha(SOURCE) == recent["source_tree_sha256"],
            "source differs from the latest ntt_opt stage profile")
    manifest = json.loads((build / "generated/manifest.json").read_text())
    require(manifest["mode"] == mode and Path(manifest["source"]) == SOURCE,
            "wrong source or profiling mode")
    hooks = {}
    for name, row in manifest["files"].items():
        require(source_files[name] == row["sha256"], "stale source: " + name)
        hooks.update(row["hooks"])
    expected_hooks = {"solve_NTRU"}
    if mode == "fft":
        expected_hooks |= {"vect_FFT", "vect_iFFT", "vect_mul_fft",
                           "vect_div_selfadj_fft", "vect_inv_mul2e_fft", "poly_big_to_fixed"}
    require(set(hooks) == expected_hooks, "incorrect hook set")
    baseline = json.loads((ROOT / "results/control/validated.json").read_text())
    old_run = Path(baseline["run_directory"])
    require(baseline["valid"] and sha(old_run / "raw.log") == baseline["raw_log_sha256"],
            "historical output reference changed")
    paths = [ROOT / name for name in ("instrument.py", "profile.c", "profile.h",
             "benchmark.c", "CMakeLists.txt", "build.sh", "run.py", "latest.py")]
    paths += [WORK / "ntt_final_compare/exec_board.py", COMMON / "exec_with_tcm_init.py",
              COMMON / "app/dtcm_startup.s", COMMON / "app/generate_dtcm_linker.py",
              COMMON / "app/fndsa.conf"]
    return {"source_dir": str(SOURCE), "source_files": source_files,
            "source_tree_sha256": tree_sha(SOURCE), "hooks": hooks,
            "harness": {str(p): sha(p) for p in paths},
            "generated": {p.name: sha(p) for p in sorted((build / "generated").iterdir())
                          if p.suffix in (".c", ".json")},
            "baseline_raw_sha256": baseline["raw_log_sha256"]}


def inspect_build(candidate):
    build = ROOT / "build" / candidate
    rows = json.loads((build / "compile_commands.json").read_text())
    expected = {build / "generated" / (name + ".c") for name in instrument.SOURCES}
    expected |= {SOURCE / (name + ".s") for name in ASM}
    selected = set()
    for row in rows:
        path = Path(row["file"])
        if path in expected:
            require(path not in selected, "duplicate crypto source")
            selected.add(path)
            args = shlex.split(row["command"])
            require(all(flag in args for flag in ("-DFNDSA_MVE_MP31=1",
                    "-DFNDSA_ASM_CORTEXM4=1", "-DFNDSA_ASM_CORTEXM55=1",
                    "-mcpu=cortex-m55")), "incorrect crypto backend flags")
            opts = [a for a in args if re.fullmatch(r"-O[0-3sgz]|-Ofast", a)]
            require(opts and opts[-1] == "-O3", "crypto is not O3")
        else:
            require(path.stem not in instrument.SOURCES + ASM,
                    "unexpected crypto translation unit: " + str(path))
    require(selected == expected, "missing crypto source")
    for name in ("zephyr/.config", "fndsa_dtcm_linker.ld"):
        require((build / name).read_bytes() ==
                (WORK / "stage_profile_compare/build/ntt_opt" / name).read_bytes(),
                "settings differ from latest stage profile: " + name)
    toolchain = COMMON / "env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin"
    output = subprocess.check_output([str(toolchain / "arm-none-eabi-nm"), "-n",
                                      str(build / "zephyr/zephyr.elf")], text=True)
    symbols = {v[2]: int(v[0], 16) for line in output.splitlines()
               if len(v := line.split()) == 3 and re.fullmatch(r"[0-9a-fA-F]+", v[0])}
    require(symbols["__fndsa_itcm_end"] <= 0x10020000, "ITCM limit exceeded")
    require(symbols["_image_ram_end"] <= 0x30040000, "DTCM limit exceeded")
    artifacts = ("zephyr/zephyr.elf", "zephyr/zephyr.map", "zephyr/.config",
                 "compile_commands.json", "CMakeCache.txt", "fndsa_dtcm_linker.ld")
    return {"artifacts": {name: sha(build / name) for name in artifacts},
            "compiled_crypto": sorted(str(p) for p in selected),
            "itcm_used": symbols["__fndsa_itcm_end"] - 0x10000000,
            "dtcm_reserved": symbols["_image_ram_end"] - 0x30000000,
            "symbols": {name: hex(symbols[name]) for name in ("fndsa_mp_NTT",
                "fndsa_mp_iNTT", "fndsa_vect_FFT", "fndsa_vect_iFFT")}}


def check(candidate):
    saved = json.loads((ROOT / "build" / candidate / "provenance.json").read_text())
    require(saved.get("ready"), "build is not recorded")
    require(saved["inputs"] == inputs(candidate), "inputs changed after build")
    require(saved["build"] == inspect_build(candidate), "build changed after recording")
    return saved


def load(candidate):
    v = json.loads((ROOT / "results" / candidate / "validated.json").read_text())
    run_dir = Path(v["run_directory"])
    data = json.loads((run_dir / "run.json").read_text())
    require(v["valid"] and data["valid"], "invalid run")
    require(sha(run_dir / "raw.log") == v["raw_log_sha256"], "raw log changed")
    raw = re.sub(r"Info : [^\n]*\n", "", (run_dir / "raw.log").read_text())
    require(not validate(raw, candidate)[-1], "raw-log validation failed")
    require(data["build_provenance"] == check(candidate), "provenance mismatch")
    return data, run_dir


def report():
    control, control_dir = load("ntt_opt_control")
    focused, focused_dir = load("ntt_opt_fft")
    require(control["source_tree_sha256"] == focused["source_tree_sha256"], "different sources")
    require(control["fingerprints"] == focused["fingerprints"], "different output keys")
    old_v = json.loads((ROOT / "results/detailed/validated.json").read_text())
    old = json.loads((Path(old_v["run_directory"]) / "run.json").read_text())
    names = [("fft", "FFT"), ("ifft", "iFFT"),
             ("fxp_spectral", "FFT 영역 곱셈·나눗셈"),
             ("fixed_convert", "큰 정수 → 고정소수점 근사 변환"),
             ("other", "나머지 정수 연산·제어·반올림 등")]
    summary = {"source_tree_sha256": focused["source_tree_sha256"],
               "control_run": str(control_dir), "fft_run": str(focused_dir), "degrees": {}}
    lines = ["# 최신 ntt_opt: NTRU solve 내부 FFT 비중", "",
             "현재 Slothy 적용 전 `fn-dsa_m55/ntt_opt`를 실제 M55 보드에서 재측정했다.",
             "공통 q-NTT 수동 최적화와 최신 K4-C RNS 어셈블리를 모두 켰으며 암호 소스는 변경하지 않았다.",
             "분모는 NTRU solve 전체 누적 사이클이다. 후보 생성·검사 및 공개키 계산은 포함하지 않는다.", "",
             "## FFT 관련 비중", "", "| 구간 | 512 | 1024 |", "|---|---:|---:|"]
    for degree in (512, 1024):
        t, c = focused["totals"][str(degree)], control["totals"][str(degree)]
        require(t["calls"] == c["calls"], "NTRU call count mismatch")
        values = {name: focused["kernels"][f"{degree}_{name}"] for name, _ in names}
        require(sum(v["cycles"] for v in values.values()) == t["total"], "sum mismatch")
        for name, _ in names:
            if name != "other":
                require(values[name]["entries"] == old["kernels"][f"{degree}_{name}"]["entries"],
                        "historical execution path changed: " + name)
        ratios = {name: 100 * v["cycles"] / t["total"] for name, v in values.items()}
        ratios["fft_ifft"] = ratios["fft"] + ratios["ifft"]
        ratios["fft_with_spectral"] = ratios["fft_ifft"] + ratios["fxp_spectral"]
        summary["degrees"][str(degree)] = {"ratios": ratios, "kernels": values,
            "ntru_calls": t["calls"], "total_cycles": t["total"],
            "focused_cycles_per_call": t["total"] / t["calls"],
            "control_cycles_per_call": c["total"] / c["calls"],
            "observed_instrumentation_delta_pct": 100 * (t["total"] / c["total"] - 1)}
    for name, label in names + [("fft_ifft", "FFT+iFFT 小計"),
                               ("fft_with_spectral", "FFT+iFFT+곱셈·나눗셈 小計")]:
        vals = [summary["degrees"][str(d)]["ratios"][name] for d in (512, 1024)]
        lines.append(f"| {label.replace('小計', '소계')} | {vals[0]:.4f}% | {vals[1]:.4f}% |")
    lines += ["", "첫 다섯 행의 합계가 100%이며 소계 행은 중복 합산하지 않는다.", "",
              "## 실제 사이클과 계측 영향"]
    for degree in (512, 1024):
        d = summary["degrees"][str(degree)]
        lines += ["", f"### {degree}", "",
                  f"- 키생성 10회, NTRU solve {d['ntru_calls']}회(실패 후 재시도 포함).",
                  f"- 최소 계측 대조군: {d['control_cycles_per_call']:,.2f} cycles/NTRU call.",
                  f"- FFT 상세 계측: {d['focused_cycles_per_call']:,.2f} cycles/NTRU call.",
                  f"- 관측 차이: {d['observed_instrumentation_delta_pct']:+.4f}%.", "",
                  "| 구간 | cycles/NTRU call | 호출 횟수 합계 |", "|---|---:|---:|"]
        for name, label in names:
            value = d["kernels"][name]
            lines.append(f"| {label} | {value['cycles']/d['ntru_calls']:,.2f} | {value['entries']} |")
    lines += ["", "## 조건·검증·한계", "",
              "- NUCLEO-N657X0-Q, Cortex-M55 r1p1, CPU 800 MHz, 프로브 003C00223335510735383531.",
              "- ITCM/DTCM 256 KiB, 코드 lower 128 KiB ITCM, 상수·데이터·스택 DTCM, I/D cache OFF, TCM ECC ON.",
              "- GCC 15.2.1, 최종 -O3, M4 어셈블리 ON, M55 q-NTT 및 RNS MVE ON.",
              "- 기존 NTRU 상세 프로파일과 동일한 키생성 seed 10개/차수, IRQ OFF, DWT CYCCNT.",
              "- control: NTRU 진입/반환만 계측. fft: 이에 더해 FFT/iFFT/세 spectral 함수/poly_big_to_fixed만 계측.",
              "- 각 범주의 배타적 사이클 합이 NTRU 전체와 일치. 후보 검사에서 호출된 FFT는 NTRU 밖이므로 제외된다.",
              "- 두 펌웨어의 출력 키 지문이 서로 일치하고 기존 deterministic 기준과도 일치한다.",
              "- 각 최종 키의 정상 서명 검증 및 변조 서명 거부 PASS. 시작·종료 ECC 설정과 fault 상태 검사 PASS.",
              "- FFT 관련 함수 호출 횟수도 기존 상세 기록과 일치한다. 전체 upstream KAT/상수시간 증명을 새로 수행한 것은 아니다.",
              "- 계측 오버헤드 포함 비중이다. control과의 차이는 훅 비용뿐 아니라 코드 배치 영향도 포함하므로 보정값으로 빼지 않는다.",
              "- 예전 전체 커널 상세 계측과 훅 수가 다르므로 비중 차이를 전부 NTT 최적화 효과로 해석하지 않는다.",
              "- 여기서 모든 정수 연산을 FP64로 바꿀 수 있다는 의미는 아니다. 고정소수점 근사 계산의 후보 범위다.", "",
              "## 재현과 원본 자료", "", "```sh",
              "bash fn-dsa_m55/ntru_profile/build.sh latest",
              "python3 -B fn-dsa_m55/ntru_profile/run.py ntt_opt_control",
              "python3 -B fn-dsa_m55/ntru_profile/run.py ntt_opt_fft",
              "python3 -B fn-dsa_m55/ntru_profile/latest.py ntt_opt_fft report", "```", "",
              f"- 측정 완료 UTC: `{focused['ended_utc']}`",
              f"- 암호 소스 트리 SHA-256: `{focused['source_tree_sha256']}`",
              f"- [최소계측 원시 로그]({control_dir / 'raw.log'})",
              f"- [FFT 계측 원시 로그]({focused_dir / 'raw.log'})",
              f"- [FFT 계측 검증·소스·빌드 기록]({focused_dir / 'run.json'})", ""]
    (ROOT / "results/ntt_opt_fft/summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    target = SOURCE / "ntru_fft_profile_result.md"
    target.write_text("\n".join(lines))
    print(target)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", choices=CANDIDATES)
    parser.add_argument("action", choices=("prepare", "record", "check", "report"))
    args = parser.parse_args()
    target = ROOT / "build" / args.candidate / "provenance.json"
    if args.action == "prepare":
        target.write_text(json.dumps({"ready": False, "inputs": inputs(args.candidate)}, indent=2) + "\n")
    elif args.action == "record":
        data = json.loads(target.read_text())
        require(data["inputs"] == inputs(args.candidate), "inputs changed during build")
        data.update(ready=True, build=inspect_build(args.candidate))
        target.write_text(json.dumps(data, indent=2) + "\n")
    elif args.action == "check":
        check(args.candidate)
    else:
        report()
    print("NTRU_LATEST " + args.candidate + " " + args.action + " PASS")


if __name__ == "__main__":
    main()
