#!/usr/bin/env python3
"""Revalidate raw measurements and report four non-overlapping auxiliary scopes."""
from __future__ import annotations
import json
from pathlib import Path
import re
import sys
sys.dont_write_bytecode = True
import provenance
import run

ROOT = Path(__file__).resolve().parent
TABLE = [c for c in run.CATEGORIES if c.startswith("table_")]
RNS = [c for c in run.CATEGORIES if c.startswith("rns_")]
GROUPS = {"상수표 생성": TABLE, "mqpoly_mul_ntt": ["mq_mul"],
          "mqpoly_div_ntt": ["mq_div"], "RNS 점별 연산": RNS,
          "나머지": ["other", "ntru_rest"]}
OP_NAMES = {"keygen": "키생성", "sign": "서명", "verify": "검증"}
LABELS = {"table_gm": "mp_mkgm", "table_igm": "mp_mkigm", "table_both": "mp_mkgmigm",
          "rns_descent": "재귀 하강: f,g의 norm/resultant 곱셈",
          "rns_lifting": "상승: F lifting 곱셈",
          "rns_depth0_babai": "depth 0: G 계산 + Babai 분자·분모 (mp_div 포함)",
          "rns_depth0_recover": "depth 0: F 보정 + G 재계산 (mp_div 포함)",
          "rns_scaled_sub": "poly_sub_scaled_ntt: k·f 점별 곱셈",
          "rns_depth1_sub": "depth 1: N(f)·k 계산 및 F 차감"}

def checked(directory, mode):
    metadata = json.loads((directory / "run.json").read_text())
    raw_path = directory / "raw.log"
    raw = re.sub(r"Info : [^\n]*\n", "", raw_path.read_text())
    totals, categories, fingerprints, errors = run.validate(raw, mode)
    provenance.require(not errors and metadata["valid"] and metadata["returncode"] == 0,
                       f"invalid run: {directory}: {errors}")
    provenance.require(metadata["raw_log_sha256"] == run.sha(raw_path), "raw log changed")
    provenance.require(metadata["build_provenance"] == provenance.check(mode), "build changed since measurement")
    provenance.require(metadata["totals"] == {f"{d}_{op}": x for (d, op), x in totals.items()}, "recorded totals differ")
    provenance.require(metadata["categories"] == {f"{d}_{op}_{c}": x for (d, op, c), x in categories.items()}, "recorded categories differ")
    provenance.require(metadata["fingerprints"] == {str(k): v for k, v in fingerprints.items()}, "recorded fingerprints differ")
    return dict(metadata=metadata, directory=str(directory), totals=totals, categories=categories)

def load_latest(mode):
    record = json.loads((ROOT / "results" / mode / "validated.json").read_text())
    directory = Path(record["run_directory"])
    data = checked(directory, mode)
    provenance.require(record["valid"] and record["raw_log_sha256"] == data["metadata"]["raw_log_sha256"], "latest pointer mismatch")
    return data

def sum_cycles(data, degree, operation, categories):
    return sum(data["categories"][(degree, operation, c)]["cycles"] for c in categories)

def main():
    control, detailed = load_latest("control"), load_latest("detailed")
    repeats = [checked(p.parent, "detailed") for p in sorted((ROOT / "results/detailed/runs").glob("*/run.json"))
               if json.loads(p.read_text()).get("valid")]
    lines = ["# ref_preslothy — NTT 보조 연산 비중 실측", "",
             "대상은 현재 M55의 `ntt_ntrusolve/ref_preslothy`이다. M4 실측이나 과거 ref의 비중이 아니다.", "",
             "## 조건과 범위", "",
             "- NUCLEO-N657X0-Q / STM32N657 / Cortex-M55 r1p1, CPU 800 MHz.",
             "- 코드 ITCM, 상수·데이터·스택 DTCM, 각각 256 KiB. I/D cache OFF, TCM ECC ON.",
             "- `mlkem-native` 637d076 기반 기존 로더·Zephyr 4.4.1·GCC 15.2.1·`-O3`를 그대로 사용.",
             "- M4/M55 어셈블리 ON, `FNDSA_MVE_MP31=1`. 이 폴더의 C 및 6개 asm만 암호 소스로 빌드.",
             "- 이전 단계 프로파일과 같은 seed·메시지·입력 및 키생성 10회 / 서명 100회 / 검증 100회 (각 512/1024).",
             "- DWT CYCCNT, API 계측 중 IRQ OFF. 검증·출력 지문 계산·로그 출력은 해당 API 시간 밖.",
             "- control은 API 총시간과 solve_NTRU 전체만 계측. detailed는 추가 함수/루프 구간을 계측.",
             "- 원본 암호 코드 31개는 변경하지 않았다. 별도 build/generated에 타이머 삽입본을 생성했다.",
             "- q-NTT 곱셈은 계측 전용 wrapper가 같은 로컬 asm을 호출한다. 암호 구현 교체용 링크 선택이 아니다.", "",
             "상수표는 `mp_mkgm/mp_mkigm/mp_mkgmigm`의 RNS용 동적 생성이다. q=12289의 미리 저장된 표를 읽는 시간은 이 항목이 아니다.",
             "RNS 점별 연산은 NTT 영역의 9개 루프만 포함한다. CRT, RNS 변환, NTT/iNTT butterfly, FFT, 복사 등은 제외한다. "
             "단, depth 0의 두 구간은 `mp_div()` 모듈러 나눗셈을 포함하므로 순수 곱셈 비중으로 해석하면 안 된다.", "",
             "## 1. 키생성·서명·검증 전체를 각각 100%로 본 비중", "",
             "계산식: `해당 구간 누적 cycles / 해당 API 누적 cycles × 100`. 서로 배타적인 구간이므로 원자료 합은 정확히 100%. 표시는 반올림했다.", "",
             "| 크기 | 단계 | 상수표 생성 | mqpoly_mul_ntt | mqpoly_div_ntt | RNS 점별 연산 | 나머지 |",
             "|---|---|---:|---:|---:|---:|---:|"]
    summaries = []
    for d in (512, 1024):
        for op in OP_NAMES:
            total = detailed["totals"][(d, op)]
            cycles = {g: sum_cycles(detailed, d, op, cats) for g, cats in GROUPS.items()}
            provenance.require(sum(cycles.values()) == total["total"], "group sum mismatch")
            percent = {g: 100 * c / total["total"] for g, c in cycles.items()}
            lines.append(f"| {d} | {OP_NAMES[op]} | " + " | ".join(f"{v:.2f}%" for v in percent.values()) + " |")
            summaries.append(dict(degree=d, operation=op, total=total, cycles=cycles, percent=percent))
    lines += ["", "0%는 이번 경로에서 호출되지 않았다는 뜻이다. '나머지'에는 이미 최적화한 NTT/iNTT 변환과 CRT·Bezout·FFT·sampler·hash 등이 포함된다.", "",
              "## 2. NTRU solve만 다시 100%로 보았을 때", "",
              "NTRU 총시간은 `ntru_rest + table_* + rns_*`의 합이다. 공개키 계산의 mqpoly_div_ntt는 NTRU 밖이므로 포함하지 않는다.", "",
              "| 크기 | NTRU / 전체 키생성 | 상수표 / NTRU | RNS 점별 / NTRU | NTRU 나머지 |",
              "|---|---:|---:|---:|---:|"]
    for d in (512, 1024):
        ntru = sum_cycles(detailed, d, "keygen", ["ntru_rest"] + TABLE + RNS)
        tab = sum_cycles(detailed, d, "keygen", TABLE)
        rns = sum_cycles(detailed, d, "keygen", RNS)
        total = detailed["totals"][(d, "keygen")]["total"]
        lines.append(f"| {d} | {100*ntru/total:.2f}% | {100*tab/ntru:.2f}% | {100*rns/ntru:.2f}% | {100*(ntru-tab-rns)/ntru:.2f}% |")
    lines += ["", "## 3. 내부 구간 상세 (전체 키생성 기준)", "",
              "cycles/키생성은 모든 재시도 시간을 포함한 누적 cycles / 성공 키생성 10회이다. entries는 전체 실행에서 계측 구간에 들어간 횟수이며 원소별 곱셈 횟수가 아니다.", "",
              "| 구간 | 512 cycles/키생성 | 512 비중 | 512 entries | 1024 cycles/키생성 | 1024 비중 | 1024 entries |",
              "|---|---:|---:|---:|---:|---:|---:|"]
    for cat, label in LABELS.items():
        fields = []
        for d in (512, 1024):
            stat = detailed["categories"][(d, "keygen", cat)]
            total = detailed["totals"][(d, "keygen")]
            fields += [f'{stat["cycles"]/total["calls"]:,.1f}', f'{100*stat["cycles"]/total["total"]:.3f}%', f'{stat["entries"]:,}']
        lines.append(f"| {label} | " + " | ".join(fields) + " |")
    lines += ["", "### q-NTT 계수별 곱셈·나눗셈 호출", "",
              "| 크기 | 함수 | cycles/함수 호출 | 키생성당 호출 | 서명당 호출 | 검증당 호출 |",
              "|---|---|---:|---:|---:|---:|"]
    for d in (512, 1024):
        for cat, name in (("mq_mul", "mqpoly_mul_ntt"), ("mq_div", "mqpoly_div_ntt")):
            s = detailed["categories"][(d, "sign", cat)]
            counts = [detailed["categories"][(d, op, cat)]["entries"] / run.EXPECTED_CALLS[op] for op in OP_NAMES]
            lines.append(f'| {d} | {name} | {s["cycles"]/s["entries"]:,.1f} | ' + ' | '.join(f'{x:g}' for x in counts) + ' |')
    lines += ["", "## 4. 계측 영향과 재현성", "",
              "아래 차이는 타이머 비용뿐 아니라 타이머 삽입에 따른 레지스터 배치·인라이닝·코드 배치 변화까지 포함한다. "
              "이를 각 항목에서 일괄 차감하지 않았다. 세부 비중은 계측 실행의 관측치이며 무계측 실행의 정확한 함수별 비중 또는 오차 한계가 아니다.", "",
              "| 크기 | 단계 | control cycles/API | detailed cycles/API | 관측된 총시간 차이 |",
              "|---|---|---:|---:|---:|"]
    for d in (512, 1024):
        for op in OP_NAMES:
            a, b = control["totals"][(d, op)], detailed["totals"][(d, op)]
            lines.append(f'| {d} | {OP_NAMES[op]} | {a["total"]/a["calls"]:,.2f} | {b["total"]/b["calls"]:,.2f} | {100*(b["total"]/a["total"]-1):+.4f}% |')
    lines += ["", f"세부 계측은 같은 ELF로 {len(repeats)}회 독립 실행했다. 각 실행마다 512/1024 모두 동일한 위 반복 횟수를 적용했다.", "",
              "| 크기 | 단계 | 재실행 간 API 총 cycles 최댓값−최솟값 |",
              "|---|---|---:|"]
    for d in (512, 1024):
        for op in OP_NAMES:
            values = [r["totals"][(d, op)]["total"] for r in repeats]
            lines.append(f"| {d} | {OP_NAMES[op]} | {max(values)-min(values)} |")
    lines += ["", "- 키·공개키·서명의 기존 FNV-1a 출력 지문 일치: 512 `9895079d`, 1024 `a020dd02`.",
              "- 정상 서명 검증 및 변조 서명 거부 PASS. 프로파일 스택/합계 오류 0. CFSR/HFSR/AFSR 모두 0.",
              "- 이는 현재 workload의 회귀 확인이며 전체 KAT corpus·수학적 오차증명·상수시간 검사를 새로 실행했다는 뜻은 아니다.",
              "- 이번에는 최적화를 구현하지 않았고 암호 소스의 변경도 없다.", "",
              "## 5. 소스 경계", "",
              "아래 줄 번호는 원본 파일 기준. 루프 본문의 SHA-256은 build/generated/manifest.json에도 기록했다.", "",
              "| 파일 | 함수 | 구간 | 원본 줄 |", "|---|---|---|---|"]
    for filename, metadata in detailed["metadata"]["build_provenance"]["inputs"]["generated"].items():
        for s in metadata["sites"]:
            loc = str(s["line"]) + ("–" + str(s["last_line"]) if "last_line" in s else " (함수 전체)")
            link = f'[{filename}]({provenance.SOURCE / filename}:{s["line"]})'
            lines.append(f'| {link} | {s["function"]} | {s["category"]} | {loc} |')
    lines += [f'| [mq_cm55.s]({provenance.SOURCE / "mq_cm55.s"}:723) | fndsa_mqpoly_mul_ntt | CAT_MQ_MUL | 함수 전체 (계측 wrapper) |', "",
              "## 6. 원본 로그와 빌드 증거", "",
              f'- 원본 암호 소스 SHA-256: `{provenance.EXPECTED_TREE}`',
              "- 상세 계측 빌드: ITCM 105,084 B / 262,144 B, DTCM 221,568 B / 262,144 B (정적 stack 예약 포함).",
              "- control 빌드: ITCM 104,796 B, DTCM 221,568 B. 둘 다 용량 이내.",
              "- linker의 FLASH/RAM 이름은 각각 0x10000000 ITCM / 0x30000000 DTCM이다. 물리 flash 실행이 아니다."]
    for label, data in [("control", control)] + [("detailed " + Path(r["directory"]).name, r) for r in repeats]:
        path = Path(data["directory"])
        lines += [f'- {label}: [raw.log]({path / "raw.log"}), [run.json]({path / "run.json"})',
                  f'  - ELF SHA-256: `{data["metadata"]["elf_sha256"]}`']
    lines += ["", "재실행 방법:", "", "```sh",
              "bash fn-dsa_m55/ntt_aux_profile/build.sh all",
              "python3 -B fn-dsa_m55/ntt_aux_profile/run.py control",
              "python3 -B fn-dsa_m55/ntt_aux_profile/run.py detailed",
              "python3 -B fn-dsa_m55/ntt_aux_profile/test_profile.py -v",
              "python3 -B fn-dsa_m55/ntt_aux_profile/report.py", "```", "",
              "run.py는 지정된 M55 보드 접근 승인이 필요하다. M4 보드는 사용하지 않는다.", ""]
    output = provenance.SOURCE / "ntt_aux_profile_result.md"
    output.write_text("\n".join(lines))
    (ROOT / "results/summary.json").write_text(json.dumps(dict(
        control_run=control["directory"], detailed_run=detailed["directory"],
        detailed_repeats=[r["directory"] for r in repeats],
        source_tree_sha256=provenance.EXPECTED_TREE, groups=summaries), indent=2, ensure_ascii=False) + "\n")
    print(output)

if __name__ == "__main__":
    main()
