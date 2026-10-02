#!/usr/bin/env python3
"""Compare the archived ref stage profile with a fresh ref_preslothy run.

Original reports and historical raw logs remain untouched. The selected
after-run is the last validated run, not the fastest run or a mixed minimum.
"""
from __future__ import annotations

import json
import os
from pathlib import Path
import re
import sys

sys.dont_write_bytecode = True
import report
import run as runner
import provenance

ROOT = Path(__file__).resolve().parent
OUTPUT = provenance.SOURCE / "stage_profile_result.md"
SCOPE = {
    "kg_check": "f 가역성 검사의 q-NTT",
    "kg_ntru": "내부 RNS NTT/iNTT (logn≥4); CRT/Bezout/FFT는 미변경",
    "kg_pk_compute": "h 계산의 q-NTT/iNTT",
    "sg_key_prep": "G 복원의 q-NTT/iNTT",
    "sg_recon_norm": "벡터 복원의 q-NTT/iNTT",
    "vr_ntt": "q-NTT/iNTT; 계수별 곱셈은 미변경",
}


def require(ok, message):
    if not ok:
        raise RuntimeError(message)


def checked_run(directory, candidate):
    path = Path(directory)
    data = json.loads((path / "run.json").read_text())
    require(data.get("valid") and not data.get("validation_errors"), "invalid run: " + str(path))
    require(data["candidate"] == candidate and data["returncode"] == 0, "wrong candidate/exit status")
    require(report.sha256(path / "raw.log") == data["raw_log_sha256"], "raw log changed")
    raw = re.sub(r"Info : [^\n]*\n", "", (path / "raw.log").read_text())
    totals, categories, fingerprints, errors = runner.validate(raw, candidate)
    require(not errors, "raw revalidation failed: " + repr(errors))
    require(data["totals"] == {f"{d}_{op}": row for (d, op), row in totals.items()},
            "stored totals differ from raw log")
    require(data["categories"] == {f"{d}_{op}_{c}": row for (d, op, c), row in categories.items()},
            "stored categories differ from raw log")
    require(data["fingerprints"] == {str(d): value for d, value in fingerprints.items()},
            "stored fingerprints differ from raw log")
    return data


def compatible(before, after):
    require(before["fingerprints"] == after["fingerprints"], "output fingerprints differ")
    for degree in report.DEGREES:
        for operation in report.OPERATIONS:
            key = f"{degree}_{operation}"
            require(before["totals"][key]["calls"] == after["totals"][key]["calls"], "call counts differ")
            for name in report.CATEGORIES:
                require(report.category(before, degree, operation, name)["entries"] ==
                        report.category(after, degree, operation, name)["entries"],
                        f"phase-entry counts differ: {key}_{name}")


def metrics(before_cycles, after_cycles, calls):
    return {"before_cycles_per_call": before_cycles / calls,
            "after_cycles_per_call": after_cycles / calls,
            "speedup": before_cycles / after_cycles if after_cycles else None,
            "cycle_reduction_pct": report.change(before_cycles, after_cycles)}


def link(path, label):
    return f"[{label}]({os.path.relpath(path, OUTPUT.parent)})"


def main():
    bv, _, before_dir = report.load("before")
    av, _, after_dir = report.load("preslothy")
    before = checked_run(before_dir, "before")
    after = checked_run(after_dir, "preslothy")
    build = provenance.check()
    require(after["build_provenance"] == build, "selected run is not the current recorded build")
    require(build["inputs"]["baseline"] == bv, "baseline selection changed since build")
    compatible(before, after)
    repeats = []
    for path in sorted((ROOT / "results/preslothy/runs").iterdir()):
        if path == after_dir or not (path / "run.json").is_file():
            continue
        candidate = json.loads((path / "run.json").read_text())
        if not candidate.get("valid") or candidate.get("elf_sha256") != after["elf_sha256"]:
            continue
        data = checked_run(path, "preslothy")
        compatible(before, data)
        require(data["build_provenance"] == build, "repeat used different build inputs")
        repeats.append((path, data))

    comparison = {
        "before": bv, "after": av, "same_phase_entries": True,
        "same_output_fingerprints": True, "build_provenance": build,
        "totals": {}, "phases": {},
        "repeat_runs": [str(path) for path, _ in repeats],
        "selection": "last validated session; no best-of or per-phase mixing",
    }
    for degree in report.DEGREES:
        for operation in report.OPERATIONS:
            key = f"{degree}_{operation}"
            bt, at = before["totals"][key], after["totals"][key]
            comparison["totals"][key] = metrics(bt["total"], at["total"], bt["calls"])
            for name, label in report.PHASES[operation]:
                bc = report.category(before, degree, operation, name)["cycles"]
                ac = report.category(after, degree, operation, name)["cycles"]
                value = metrics(bc, ac, bt["calls"])
                value.update(label=label, before_share_pct=report.share(bc, bt["total"]),
                             after_share_pct=report.share(ac, at["total"]),
                             optimized_part=SCOPE.get(name, "미변경"))
                comparison["phases"][key + "_" + name] = value

    lines = [
        "# M55 ref → ref_preslothy: 단계별 연산비중 재측정",
        "",
        f"새 측정 종료 UTC: `{after['ended_utc']}`. 실제 M55 보드 측정·검증 완료.",
        "",
        "- 전: 기존 `fn-dsa_m55/ref`의 **M4 어셈블리 ON** 프로파일. 현재 폴더 이름은 "
        "`fn-dsa_m55/M55_ref`이며 전체 C/H/S 소스 해시가 기존 기록과 일치한다.",
        "- 후: `fn-dsa_m55/ntt_ntrusolve/ref_preslothy` 자체의 소스. "
        "공통 q-NTT 및 NTRU 내부 RNS NTT 최적화를 포함하며 **Slothy는 미적용**이다.",
        "- `ntt_opt_slothy`의 이전 후 비중이나 D1의 비계측 API 수치를 섞지 않았다. "
        "암호 소스는 수정하지 않고 빌드 폴더의 C 복사본에만 기존 계측 훅을 적용했다.",
        "",
        "## 전체 API: 이번 계측 빌드 기준",
        "",
        "단위 cycles/call, 합계/호출 수의 산술평균. 속도 배수=전/후; "
        "사이클 감소율=100×(전−후)/전. 음수는 느려짐이다.",
        "",
        "| 크기 | 연산 | 전 cycles/call | 후 cycles/call | 속도 배수 | 사이클 감소율 |",
        "|---|---|---:|---:|---:|---:|",
    ]
    for degree in report.DEGREES:
        for operation in report.OPERATIONS:
            v = comparison["totals"][f"{degree}_{operation}"]
            lines.append(f"| {degree} | {report.OP_LABEL[operation]} | {v['before_cycles_per_call']:,.2f} | "
                         f"{v['after_cycles_per_call']:,.2f} | {v['speedup']:.4f}배 | {v['cycle_reduction_pct']:+.4f}% |")

    lines += ["", "## 각 API를 100%로 나눈 단계별 비중", "",
              "각 단계의 배타적 사이클 합은 해당 API 총 사이클과 정확히 일치한다. "
              "표시 반올림으로 표의 합은 100%에서 조금 벗어날 수 있다."]
    for operation in report.OPERATIONS:
        lines += ["", f"### {report.OP_LABEL[operation]}", "",
                  "| 단계 | 512 전 → 후 | 1024 전 → 후 | 최적화한 부분 |",
                  "|---|---:|---:|---|"]
        for name, label in report.PHASES[operation]:
            cells = []
            for degree in report.DEGREES:
                v = comparison["phases"][f"{degree}_{operation}_{name}"]
                cells.append(f"{v['before_share_pct']:.2f}% → {v['after_share_pct']:.2f}%")
            lines.append(f"| {label} | " + " | ".join(cells) + f" | {SCOPE.get(name, '미변경')} |")
        lines.append("| 합계 | 100% → 100% | 100% → 100% | — |")

    lines += ["", "## 단계별 실제 사이클과 속도 배수"]
    for degree in report.DEGREES:
        for operation in report.OPERATIONS:
            lines += ["", f"### {degree} {report.OP_LABEL[operation]}", "",
                      "| 단계 | 전 cycles/call | 후 cycles/call | 속도 배수 | 사이클 감소율 |",
                      "|---|---:|---:|---:|---:|"]
            for name, label in report.PHASES[operation]:
                v = comparison["phases"][f"{degree}_{operation}_{name}"]
                lines.append(f"| {label} | {v['before_cycles_per_call']:,.2f} | {v['after_cycles_per_call']:,.2f} | "
                             f"{v['speedup']:.4f}배 | {v['cycle_reduction_pct']:+.4f}% |")

    ntru = [comparison["phases"][f"{d}_keygen_kg_ntru"] for d in report.DEGREES]
    ntt = [comparison["phases"][f"{d}_verify_vr_ntt"] for d in report.DEGREES]
    ldl = [comparison["phases"][f"{d}_sign_sg_ldl_ffsampling"] for d in report.DEGREES]
    lines += ["", "## 결과 해석", "",
              f"- NTRU solve 전체 사이클 감소: 512 {ntru[0]['cycle_reduction_pct']:.2f}%, "
              f"1024 {ntru[1]['cycle_reduction_pct']:.2f}%. 내부 RNS 변환만 바꿨으므로 "
              "NTRU solve의 모든 연산이 최적화되었다는 뜻은 아니다.",
              f"- 검증의 q-NTT·계수별 곱·iNTT 구간: 512 {ntt[0]['speedup']:.3f}배, "
              f"1024 {ntt[1]['speedup']:.3f}배. 이 배수는 계수별 곱셈을 포함한 상위 단계의 배수다.",
              "- 후보 검사처럼 사이클이 줄었어도 전체 키생성이 더 많이 줄면 비중은 증가할 수 있다. "
              "비중 변화와 속도 배수는 서로 다른 지표다.",
              f"- 서명에서는 키 준비·벡터 복원이 빨라진 반면, 수정하지 않은 LDL/ffSampling 구간이 "
              f"512 {-ldl[0]['cycle_reduction_pct']:.2f}%, 1024 {-ldl[1]['cycle_reduction_pct']:.2f}% "
              "더 많은 사이클로 측정되었다. FFT 준비·sampler에서도 증가가 보인다. "
              "서명 전체 증가를 숨기거나 NTT 자체의 퇴행으로 단정하지 않는다.",
              "- 후의 암호 소스는 계측 도구 추가 전후에 동일하다. 함수 배치/계측 영향과 "
              "비계측 실행에서의 영향을 분리하려면 별도의 주소 통제·비계측 대조 실험이 필요하며, "
              "이번 요청에서는 원래 계측 조건을 유지했다."]

    lines += ["", "## 동일 펌웨어 반복 확인", "",
              "아래 비교는 새 펌웨어의 재현성 확인이며 기존 ref를 다시 측정한 것은 아니다. "
              "본 표는 마지막 검증 세션 하나를 사용하고 빠른 값만 골라 합치지 않았다.", "",
              "| 크기 | 연산 | 이전 확인 세션 → 본 표 cycles/call | 세션 간 변화율 |",
              "|---|---|---:|---:|"]
    for _, data in repeats:
        for degree in report.DEGREES:
            for operation in report.OPERATIONS:
                key = f"{degree}_{operation}"
                previous, current = data["totals"][key], after["totals"][key]
                a, b = previous["total"] / previous["calls"], current["total"] / current["calls"]
                lines.append(f"| {degree} | {report.OP_LABEL[operation]} | {a:,.2f} → {b:,.2f} | {(b-a)*100/a:+.6f}% |")

    lines += [
        "", "## 측정 조건·검증·해석 한계", "",
        "- NUCLEO-N657X0-Q, Cortex-M55 r1p1, CPU 800 MHz; 프로브 `003C00223335510735383531`.",
        "- ITCM 256 KiB 코드, DTCM 256 KiB 상수·데이터·스택. 실제 배치 주소는 ELF/map에서 확인했다. "
        "링커의 `FLASH` 이름은 ITCM 영역이며 Flash 쓰기·지우기는 하지 않았다.",
        "- I/D cache OFF (`CCR=0x611`), TCM ECC ON (`MSCR=0x1300a`), TCM control `0x99`, "
        "ITCMCR/DTCMCR `0x49`. 시작·종료 Fault 상태 정상.",
        "- GCC 15.2.1, 최종 `-O3`, `-fno-reorder-functions`; 이전과 C 옵션 일치 "
        "(후의 RNS 백엔드 활성화와 로그용 후보 이름 정의 제외). Kconfig·링커 배치 정책도 byte-identical.",
        "- 512/1024 각각 키생성 10회, 서명 100회, 검증 100회. 각 크기마다 비계측 준비 호출 포함. "
        "키생성은 서로 다른 seed 10개; 서명은 마지막 키와 서로 다른 seed 100개; 검증은 마지막 서명 반복.",
        "- 기존 seed 생성식·메시지·API·워밍업을 담은 benchmark.c가 byte-identical. "
        "동일 단계 분류·훅 위치·DWT CYCCNT 계측, 계측 구간 IRQ OFF.",
        "- 모든 단계 진입 횟수 일치, 512/1024 출력 FNV-1a 지문 일치, 정상 서명 검증·변조 서명 거부 PASS. "
        "이는 이 입력 집합의 회귀 검사이며 전체 upstream KAT나 형식적 정확성·상수시간 증명이 아니다.",
        "- Gaussian/BerExp는 ffSampling 내부 호출을 별도 배타적 범주로 뺀 것이다. "
        "키생성은 FFT tree를 결과 키에 저장하지 않으며 fixed-point FFT는 후보 검사/NTRU 단계에 포함된다.",
        "- **계측 오버헤드 포함 수치**다. sampler_next의 반복 훅 비용도 포함된다. "
        "기존 비계측 D1 성능의 batch upper-median과 이 표의 산술평균을 직접 혼합하지 않는다.",
        "- 같은 M55의 구현 전후 비교지만 함수 주소·바이너리 내부 배치는 고정하지 않았다. "
        "비중 변화와 실제 속도 변화는 다르며, 미변경 함수의 사이클 변화는 곧 알고리즘 변경을 뜻하지 않는다.",
        "- 이번 계측에서 서명 시간이 증가했다면 그 값도 그대로 보고한다. "
        "함수 배치·계측 상호작용 등의 기여는 이 실험만으로 확정하지 않는다.",
        "", "## 소스·로그·재현 자료", "",
        f"- 전 소스 SHA-256: `{bv['source_tree_sha256']}`",
        f"- 후 소스 SHA-256: `{av['source_tree_sha256']}`",
        f"- 전 ELF SHA-256: `{bv['elf_sha256']}`",
        f"- 후 ELF SHA-256: `{av['elf_sha256']}`",
        f"- 전 raw log SHA-256: `{bv['raw_log_sha256']}`",
        f"- 후 raw log SHA-256: `{av['raw_log_sha256']}`",
        "- 전 원시 로그: " + link(before_dir / "raw.log", "기존 ref raw.log"),
        "- 후 원시 로그: " + link(after_dir / "raw.log", "ref_preslothy raw.log"),
        "- 후 세션/계측값/빌드 증거: " + link(after_dir / "run.json", "run.json"),
        "- 새 빌드 검증: " + link(provenance.MANIFEST, "profile_provenance.json"),
        "- 비교 원자료: " + link(ROOT / "results/preslothy/comparison.json", "comparison.json"),
        "- 실행 위치: `fn-dsa_m55/stage_profile_compare`.",
        "- 재현: `bash build.sh preslothy`, `python3 -B run.py preslothy`, `python3 -B compare_preslothy.py`.",
        "- 기존 `result.md`, before/after 원시 로그, ref 및 ref_preslothy 암호 소스는 보존했다.",
    ]
    for path, _ in repeats:
        lines.append("- 반복 확인 로그: " + link(path / "raw.log", path.name + "/raw.log"))
    OUTPUT.write_text("\n".join(lines) + "\n")
    (ROOT / "results/preslothy/comparison.json").write_text(json.dumps(comparison, indent=2, ensure_ascii=False) + "\n")
    print("REPORT=" + str(OUTPUT))
    print(json.dumps(comparison["totals"], indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
