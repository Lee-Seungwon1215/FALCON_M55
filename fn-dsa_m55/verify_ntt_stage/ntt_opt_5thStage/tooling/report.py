#!/usr/bin/env python3
"""Render the validated board comparison; never use estimated solver cycles."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def main():
    data = json.loads((ROOT / "results/comparison.json").read_text())
    assert data["complete"]
    measurements = data["measurements"]
    base = measurements["ref"]["upper_median"]
    rows = []
    for degree in (512, 1024):
        for op, label in (("keygen", "키생성"), ("sign", "서명"), ("verify", "검증")):
            key = f"{degree}_{op}"
            a, b = (measurements[n]["upper_median"][key] for n in ("slothyA", "slothyB"))
            rows.append(f"| {degree} | {label} | {base[key]:,} | {a:,} | {(base[key]-a)/base[key]*100:+.4f}% | {b:,} | {(base[key]-b)/base[key]*100:+.4f}% |")
    lines = ["# 5단계 SLOTHY A/B: 실제 M55 비교", "",
             "같은 연결 보드에서 ref/A/B를 다시 빌드하고 예비 검사 후 각각 전체 측정했다.",
             "`ref`와 기존 `../ntt_opt`는 변경하지 않았다. 아래는 실제 보드 cycle이며 SLOTHY 예상값이 아니다.", "",
             "## 전체 API 성능", "",
             "degree·작업별 100회 = 고정 입력 10종 × 입력별 10회. batch마다 10회 warm-up.",
             "대표값은 **10개 batch 평균 cycle/call의 상위 중앙값**이다. 개별 100회 시간의 중앙값은 아니다.",
             "절감률 양수는 빨라짐, 음수는 느려짐이다. 전체 키생성·서명·검증 수치이며 NTT 단독 cycle은 아니다.", "",
             "| degree | 작업 | ref | A | A 절감률 | B | B 절감률 |",
             "|---:|---|---:|---:|---:|---:|---:|"] + rows
    lines += ["", "## 현재 판단", "",
              "이번 실험에서는 A가 여섯 API 항목 모두 소폭 개선되었고 코드·데이터 메모리 증가도 없다.",
              "A의 이득은 작지만 동일 입력의 10개 batch에서 모두 같은 개선 방향이었다.",
              "B는 키생성·검증 이득이 있으나 서명은 512 약 3.71%, 1024 약 3.85% 느려져",
              "현 상태로 기준 코드에 승격하기 어렵다. 어느 후보도 기존 `ntt_opt`에 반영하지 않았다.",
              "B의 서명 지연 원인은 이번 실험에서 분리 진단하지 않았다. 코드 크기/배치 변화도 포함된",
              "전체 API 측정이므로 이 수치를 NTT 루프 자체의 지연으로 단정하지 않는다.", "",
              "## 같은 입력끼리 비교", "",
              "키생성의 재시도 횟수 등 입력별 변동을 통제하기 위해 동일 seed의 batch끼리 비교했다.",
              "아래 차이는 ref−후보이며 양수가 이득이다. 통계적 유의성 검정이나 다른 보드에 대한 일반화는 아니다.", "",
              "| 후보 | degree·작업 | paired 차이 상위 중앙값 (cycle/call) | 빠른 batch / 10 |",
              "|---|---|---:|---:|"]
    for name, groups in data["paired"].items():
        for key, g in groups.items():
            lines.append(f"| {name} | {key} | {g['upper_median_delta']:+,.1f} | {g['faster']} |")
    lines += ["", "## 조건과 메모리", "",
              "- 실제 NUCLEO-N657X0-Q, STM32N657 Cortex-M55 r1p1; ST-LINK `003C00223335510735383531`.",
              "- CPU 800 MHz, SYSCLK 400 MHz, HCLK 200 MHz. 코드 ITCM, 데이터·상수·stack DTCM; 각각 256 KiB 설정.",
              "- I/D cache 실제 OFF(CCR 확인), TCM ECC ON, 기존 IRQ 허용 조건.",
              "- GCC 15.2.1, 최종 유효 옵션 `-O3`; 동일 Zephyr 4.4.1/config/linker/startup/harness.",
              "- `mlkem-native` pinned commit `637d076aa113d8faaec2277ed4a46b657acaf35f`의 Nucleo 경로 및 기존 프로젝트 FN-DSA harness를 그대로 재사용.",
              "- config에 cache 지원 여부가 1로 출력되어도 활성 상태를 뜻하지 않는다. CCR cache-enable 비트를 따로 확인했다.", "",
              "| 후보 | ITCM 코드 | DTCM 예약 | main stack 사용 상한 |", "|---|---:|---:|---:|",
              f"| ref | 106,236 B | 225,728 B | {measurements['ref']['stack_used_upper_bound']:,} B |"]
    for name in ("slothyA", "slothyB"):
        s = data["static"][name]
        lines.append(f"| {name} | {s['itcm_code_bytes']:,} B | {s['dtcm_reserved_bytes']:,} B | {measurements[name]['stack_used_upper_bound']:,} B |")
    lines += ["", "B의 앞뒤 처리 코드 때문에 ITCM은 기준보다 5,392 B 늘었다. 두 후보 모두 기존 active-code 한계",
              "128 KiB 안에 있고 DTCM은 256 KiB 안에 있다. heap/table/stack 추가 예약은 없다.", "",
              "## 검증 결과와 한계", "",
              "- A/B: 실제 SLOTHY selfcheck 및 별도 instruction interpreter 816개 상태·메모리 접근 시험 PASS.",
              "- A/B: object에서 변경된 함수는 공통 NTT/iNTT 2개뿐. `mq.c` 등 다른 C/H/S 파일 불변.",
              "- 각 보드 full run: 512·1024 forward oracle/roundtrip 오차 0, Barrett 2048쌍 표 검사 0 mismatch.",
              "- 각 full run: host 고정-seed DIGEST/AUDIT 22개 일치, 정상 서명·검증 및 변조 거부 PASS.",
              "- 각 full run: CFSR/HFSR/AFSR=0, ECC 시작/종료 활성 상태 정상.",
              "- 상수시간: 새 비밀 의존 분기/메모리 주소/stack spill을 추가하지 않았는지 정적으로 확인.",
              "  이 결과는 형식적 CT 증명, dudect 타이밍 검정, 전력/EM TVLA가 아니다. 정수 NTT 검사이며 FFT/sampler 오차 분석도 아니다.",
              "- B: 8개 루프에 halving 적용, 실제 교차 이동은 6개. 512 CT3/마지막 GS2는 현 해에서 교차 이동 0개.",
              "  1024 중간 pass는 A의 반복 내부 스케줄만 적용. 전체 범위를 무제한 modulo scheduling한 결과가 아니다.", "",
              "## 원시 로그와 정확한 실행 파일", ""]
    for name, m in measurements.items():
        run = Path(m["run_directory"]).relative_to(ROOT).as_posix()
        lines += [f"### {name}", "", f"- [full 원시 로그]({run}/raw.log)",
                  f"- [full 실행 기록]({run}/run.json)",
                  f"- [소스·ELF 검증 기록](results/{name}/full_validated.json)",
                  f"- source tree SHA-256: `{m['source_tree_sha256']}`",
                  f"- ELF SHA-256: `{m['elf_sha256']}`", ""]
    lines += ["[구현 범위·논문 근거·재현 명령](README.md), [전체 기계 판독 결과](results/comparison.json),",
              "[SLOTHY 입력/출력 manifest](tooling/logs/manifest.json), [독립 모델 검사](tooling/logs/instruction_model.json).", ""]
    (ROOT / "RESULTS.md").write_text("\n".join(lines))
    for name in ("slothyA", "slothyB"):
        m = measurements[name]
        text = [f"# {name} 실제 M55 결과", "", "[ref/A/B 전체 비교와 로그](../RESULTS.md)", "",
                "| degree | 키생성 | 서명 | 검증 |", "|---:|---:|---:|---:|"]
        for degree in (512,1024):
            values = [m["upper_median"][f"{degree}_{op}"] for op in ("keygen","sign","verify")]
            text.append(f"| {degree} | " + " | ".join(f"{v:,}" for v in values) + " |")
        text += ["", "단위: 10개 batch 평균 cycle/call의 상위 중앙값. 각 작업 100회 실측.",
                 "보드 KAT/정상·변조 서명 검사/NTT modular error=0/PASS.",
                 "상수시간은 정적 구조 확인 수준이며 형식적 증명·동적 누설 검정을 뜻하지 않는다.", ""]
        (ROOT / name / "result.md").write_text("\n".join(text))
    print("Wrote RESULTS.md, slothyA/result.md, slothyB/result.md")


if __name__ == "__main__": main()
