#!/usr/bin/env python3
"""Provenance and standalone report for the current pre-Slothy ntt_opt profile.

Cryptographic sources and historical measurement records are never edited.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re
import shlex
import subprocess
import sys

sys.dont_write_bytecode = True
import instrument
import report as stages
from provenance import generated, require, sha, sources, tree_sha

ROOT = Path(__file__).resolve().parent
WORK = ROOT.parent
SOURCE = WORK / "ntt_opt"
BUILD = ROOT / "build/ntt_opt"
MANIFEST = BUILD / "profile_provenance.json"
COMMON = WORK / "measurement_mlkem_native"
ASM = "codec_cm4 mq_cm55 sha3_cm4 sign_fpr_cm4 sign_sampler_cm4 kgen_mp31_cm55".split()
ARTIFACTS = ("zephyr/zephyr.elf", "zephyr/zephyr.map", "zephyr/.config",
             "compile_commands.json", "CMakeCache.txt", "fndsa_dtcm_linker.ld")
ADOPTED = {
    "mq_cm55.s": "0d1c14bed961466f649d1d818732d82ba3d1f1cf87c2ca441b37edaecf5d13f9",
    "kgen_mp31_cm55.s": "bad74cbe6f569a948b70f887b47cc0c5fc9f7e6130605df27adb70f3d88ece88",
    "kgen_mp31.c": "c41e661b6cf9d6a1ac5f71cb007f37eab9667efcde928b7f76ea01155bcaedbc",
}


def inputs():
    source_files = sources(SOURCE)
    for name, digest in ADOPTED.items():
        require(source_files[name] == digest, "pre-Slothy adopted source changed: " + name)
    generated(SOURCE, BUILD)
    baseline = json.loads((ROOT / "results/before/validated.json").read_text())
    old = Path(baseline["run_directory"])
    require(baseline["valid"] and sha(old / "raw.log") == baseline["raw_log_sha256"],
            "historical correctness record is not valid")
    harness_paths = [ROOT / name for name in
                     ("profile.c", "profile.h", "instrument.py", "CMakeLists.txt",
                      "build.sh", "run.py", "ntt_opt_audit.py")]
    harness_paths += [WORK / "ntt_profile_compare/benchmark.c",
                      WORK / "ntt_final_compare/exec_board.py",
                      COMMON / "exec_with_tcm_init.py",
                      COMMON / "app/generate_dtcm_linker.py",
                      COMMON / "app/dtcm_startup.s", COMMON / "app/fndsa.conf"]
    return {
        "source_dir": str(SOURCE), "source_files": source_files,
        "source_tree_sha256": tree_sha(SOURCE),
        "harness": {str(p): sha(p) for p in harness_paths},
        "generated": {p.name: sha(p) for p in sorted((BUILD / "generated").glob("*.c"))},
        "baseline_run_sha256": sha(old / "run.json"),
        "baseline_raw_sha256": sha(old / "raw.log"),
    }


def inspect_build():
    commands = json.loads((BUILD / "compile_commands.json").read_text())
    expected = {BUILD / "generated" / (name + ".c") for name in instrument.SOURCES}
    expected |= {SOURCE / (name + ".s") for name in ASM}
    seen = set()
    for row in commands:
        path = Path(row["file"])
        if path in expected:
            require(path not in seen, "duplicate crypto source")
            seen.add(path)
            args = shlex.split(row["command"])
            for flag in ("-DFNDSA_MVE_MP31=1", "-DFNDSA_ASM_CORTEXM4=1",
                         "-DFNDSA_ASM_CORTEXM55=1", "-mcpu=cortex-m55"):
                require(flag in args, "missing flag: " + flag)
            opts = [a for a in args if re.fullmatch(r"-O[0-3sgz]|-Ofast", a)]
            require(opts and opts[-1] == "-O3", "final optimization is not O3")
        else:
            require(path.stem not in instrument.SOURCES + ASM,
                    "unexpected crypto source: " + str(path))
    require(seen == expected, "missing crypto translation unit")
    require((BUILD / "benchmark.c").read_bytes() ==
            (WORK / "ntt_profile_compare/benchmark.c").read_bytes(), "workload changed")
    require((BUILD / "benchmark.c").read_bytes() ==
            (ROOT / "build/before/benchmark.c").read_bytes(), "historical workload differs")
    for name in ("zephyr/.config", "fndsa_dtcm_linker.ld"):
        require((BUILD / name).read_bytes() == (ROOT / "build/before" / name).read_bytes(),
                "historical profile configuration differs: " + name)
    nm = COMMON / "env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-nm"
    output = subprocess.check_output([str(nm), "-n", str(BUILD / "zephyr/zephyr.elf")], text=True)
    symbols = {v[2]: int(v[0], 16) for line in output.splitlines()
               if len(v := line.split()) == 3 and re.fullmatch(r"[0-9a-fA-F]+", v[0])}
    selected = {}
    for name in ("fndsa_mqpoly_int_to_ntt", "fndsa_mqpoly_ntt_to_int",
                 "fndsa_mp_NTT", "fndsa_mp_iNTT"):
        require(name in symbols and 0x10000000 <= symbols[name] < 0x10020000,
                "NTT text outside lower ITCM: " + name)
        selected[name] = hex(symbols[name])
    require(symbols["__fndsa_itcm_end"] <= 0x10020000, "text exceeds 128 KiB")
    require(symbols["_image_ram_end"] <= 0x30040000, "DTCM overflow")
    return {
        "artifacts": {name: sha(BUILD / name) for name in ARTIFACTS},
        "compiled_crypto": sorted(str(p) for p in seen),
        "symbols": selected,
        "itcm_used": symbols["__fndsa_itcm_end"] - 0x10000000,
        "dtcm_reserved": symbols["_image_ram_end"] - 0x30000000,
        "same_historical_workload_config_and_linker_policy": True,
    }


def check():
    saved = json.loads(MANIFEST.read_text())
    require(saved.get("ready"), "build is not recorded")
    require(saved["inputs"] == inputs(), "inputs changed after build")
    require(saved["build"] == inspect_build(), "build changed after recording")
    return saved


def make_report():
    from run import validate
    validated, data, run_dir = stages.load("ntt_opt")
    require(data["build_provenance"] == check(), "run/build provenance mismatch")
    raw = re.sub(r"Info : [^\n]*\n", "", (run_dir / "raw.log").read_text())
    require(not validate(raw, "ntt_opt")[3], "raw-log validation failed")
    lines = ["# ntt_opt: Slothy 적용 전 최신 코드 단계별 연산 비중", "",
             "실제 NUCLEO-N657X0-Q 보드에서 현재 `fn-dsa_m55/ntt_opt` 소스를 새로 빌드해 측정했다.",
             "공통 q-NTT 수동 최적화와 K4-C RNS NTT 최적화를 포함하며 Slothy는 적용하지 않았다.", "",
             f"- 측정 완료 UTC: `{data['ended_utc']}`",
             "- CPU 800 MHz, ITCM/DTCM 각각 256 KiB, 코드 lower 128 KiB ITCM, 상수·데이터·스택 DTCM.",
             "- I/D cache OFF, TCM ECC ON. 시작·종료 ECC 설정 및 fault 레지스터 검사 PASS.",
             "- GCC 15.2.1, 최종 `-O3`, M4 assembly ON, M55 q-NTT 및 RNS MVE backend ON.",
             "- 512/1024 각각 키생성 10회(서로 다른 seed), 서명 100회(서로 다른 seed), 검증 100회(마지막 서명 반복).",
             "- 기존 단계 프로파일과 동일한 메시지·seed 생성식·준비 호출·단계 분류. DWT CYCCNT, 계측 구간 IRQ OFF.",
             "- 수치는 배타적 단계 사이클 합/호출 수의 산술평균. 계측 오버헤드 포함; 비계측 성능 수치가 아니다.", "",
             "## 전체 API 사이클", "", "| 크기 | 키생성 | 서명 | 검증 |", "|---|---:|---:|---:|"]
    for degree in stages.DEGREES:
        values = [data["totals"][f"{degree}_{op}"] for op in stages.OPERATIONS]
        lines.append(f"| {degree} | " + " | ".join(f"{v['total']/v['calls']:,.2f}" for v in values) + " |")
    summary = {"run_directory": str(run_dir), "totals": data["totals"], "phases": {}}
    for op in stages.OPERATIONS:
        lines += ["", "## " + stages.OP_LABEL[op], "",
                  "| 단계 | 512 cycles/call | 512 비중 | 1024 cycles/call | 1024 비중 |",
                  "|---|---:|---:|---:|---:|"]
        for name, label in stages.PHASES[op]:
            values = []
            for degree in stages.DEGREES:
                total = data["totals"][f"{degree}_{op}"]
                part = stages.category(data, degree, op, name)
                mean = part["cycles"] / total["calls"]
                pct = stages.share(part["cycles"], total["total"])
                summary["phases"][f"{degree}_{op}_{name}"] = {
                    "cycles_per_call": mean, "share_percent": pct, **part}
                values += [f"{mean:,.2f}", f"{pct:.4f}%"]
            lines.append(f"| {label} | " + " | ".join(values) + " |")
        lines.append("| 합계 | — | 100% | — | 100% |")
    lines += ["", "## 검증과 해석 범위", "",
              "- 각 API의 단계 사이클 합이 총 사이클과 정확히 일치한다. 표시 반올림으로 비중 합계에는 미세한 차이가 날 수 있다.",
              "- 모든 단계 진입 횟수와 512/1024 출력 FNV-1a 지문이 기존 deterministic 기준과 일치한다.",
              "- 정상 서명 검증 및 변조 서명 거부 PASS. 전체 upstream KAT·오차 증명·상수시간 분석을 새로 수행한 것은 아니다.",
              "- Gaussian/BerExp sampler는 LDL/ffSampling에서 배타적으로 분리했다. 두 행을 중복 집계하지 않는다.",
              "- 키생성의 fixed-point FFT는 후보 검사와 NTRU solve 안에 포함된다. 이 표는 FFT 단독 커널 비중이나 FP 명령 비중이 아니다.",
              "- 현재 키생성은 FFT basis/LDL tree를 완성된 키에 저장하지 않는다. 관련 준비·계산은 서명 단계에 포함된다.",
              "- 한 펌웨어의 단계별 비중이며, 서로 다른 버전의 함수 주소를 고정한 전후 성능 비교는 아니다.", "",
              "## 재현·원본 자료", "",
              "```sh", "bash fn-dsa_m55/stage_profile_compare/build.sh ntt_opt",
              "python3 fn-dsa_m55/stage_profile_compare/run.py ntt_opt",
              "python3 fn-dsa_m55/stage_profile_compare/ntt_opt_audit.py report", "```", "",
              f"- 소스 트리 SHA-256: `{data['source_tree_sha256']}`",
              f"- ELF SHA-256: `{data['elf_sha256']}`",
              f"- 원시 로그 SHA-256: `{data['raw_log_sha256']}`",
              f"- [원시 로그]({run_dir / 'raw.log'})",
              f"- [실행·검증·측정 원자료]({run_dir / 'run.json'})",
              f"- [소스·빌드 증거]({MANIFEST})", ""]
    target = SOURCE / "stage_profile_result.md"
    target.write_text("\n".join(lines))
    (ROOT / "results/ntt_opt/summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    print(target)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("prepare", "record", "check", "report"))
    action = parser.parse_args().action
    if action == "prepare":
        data = {"ready": False, "inputs": inputs()}
        MANIFEST.write_text(json.dumps(data, indent=2) + "\n")
    elif action == "record":
        data = json.loads(MANIFEST.read_text())
        require(data["inputs"] == inputs(), "inputs changed during build")
        data.update(ready=True, build=inspect_build())
        MANIFEST.write_text(json.dumps(data, indent=2) + "\n")
    elif action == "report":
        make_report()
    else:
        check()
    print("NTT_OPT_AUDIT " + action + " PASS")


if __name__ == "__main__":
    main()
