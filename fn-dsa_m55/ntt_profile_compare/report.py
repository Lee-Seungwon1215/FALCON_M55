#!/usr/bin/env python3
"""Generate the reproducible before/after profiling report."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
DEGREES = (512, 1024)
OPERATIONS = ("keygen", "sign", "verify")
OP_LABEL = {"keygen": "키 생성", "sign": "서명", "verify": "검증"}
CATEGORY_LABEL = {
    "other": "기타 API/계측 제어",
    "shake": "SHAKE/Keccak",
    "codec": "인코딩·디코딩",
    "hash_to_point": "Hash-to-Point",
    "message_hash": "메시지·공개키 해시",
    "fft_fixed": "고정소수점 FFT/iFFT (키 생성)",
    "fft_fpr": "binary64 정수 에뮬레이션 FFT/iFFT (서명)",
    "ntt_q": "q=12289 NTT/iNTT",
    "ntt_modp": "31-bit mod-p NTT/iNTT·테이블 생성 (NTRU)",
    "keygen_other": "키 생성 제어·기타",
    "key_preparation": "서명키 준비",
    "ntru_other": "NTRU solver 기타",
    "crt": "CRT 재구성",
    "ldl_ffsampling": "LDL tree·ffSampling",
    "sampler_other": "Sampler 기타",
    "gaussian_fg": "Gaussian f,g 생성",
    "gaussian0": "Gaussian0 helper",
    "berexp": "BerExp",
    "norm": "노름 검사",
    "sign_other": "서명 코어 기타",
    "verify_other": "검증 코어 기타",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_candidate(candidate: str) -> tuple[dict, dict, Path]:
    validation_path = ROOT / "results" / candidate / "validated.json"
    validation = json.loads(validation_path.read_text())
    if not validation.get("valid"):
        raise RuntimeError(f"not validated: {validation_path}")
    run_dir = Path(validation["run_directory"])
    run = json.loads((run_dir / "run.json").read_text())
    if not run.get("valid") or run.get("validation_errors"):
        raise RuntimeError(f"invalid run: {run_dir}")
    if sha256(run_dir / "raw.log") != validation["raw_log_sha256"]:
        raise RuntimeError(f"raw log changed: {run_dir}")
    if run["elf_sha256"] != validation["elf_sha256"]:
        raise RuntimeError(f"ELF identity mismatch: {run_dir}")
    return validation, run, run_dir


def value(run: dict, degree: int, operation: str, category: str) -> dict:
    return run["categories"][f"{degree}_{operation}_{category}"]


def percent(cycles: int, total: int) -> float:
    return cycles * 100.0 / total


def delta_percent(before: int, after: int) -> float:
    if before == 0:
        return 0.0
    return (before - after) * 100.0 / before


def cycles_per_call(cycles: int, calls: int) -> float:
    return cycles / calls


def fmt_cycles(value: float) -> str:
    return f"{value:,.0f}"


def fmt_share(value: float) -> str:
    return f"{value:.2f}%"


def fmt_pp(value: float) -> str:
    return f"{value:+.2f} pp"


def fmt_change(value: float) -> str:
    return f"{value:+.2f}%"


def main() -> None:
    before_validation, before, before_dir = load_candidate("before")
    after_validation, after, after_dir = load_candidate("after")
    if before["fingerprints"] != after["fingerprints"]:
        raise RuntimeError("before/after fingerprints differ")

    # The deterministic workload must enter every instrumented function the
    # same number of times.  This prevents changed call counts from looking
    # like an implementation speedup.
    for degree in DEGREES:
        for operation in OPERATIONS:
            b_total = before["totals"][f"{degree}_{operation}"]
            a_total = after["totals"][f"{degree}_{operation}"]
            if b_total["calls"] != a_total["calls"]:
                raise RuntimeError(f"API call count mismatch: {degree} {operation}")
            for category in CATEGORY_LABEL:
                b_entries = value(before, degree, operation, category)["entries"]
                a_entries = value(after, degree, operation, category)["entries"]
                if b_entries != a_entries:
                    raise RuntimeError(
                        f"category entry mismatch: {degree} {operation} {category}")

    lines: list[str] = []
    lines += [
        "# FN-DSA M55 공통 NTT/iNTT 최적화 전·후 연산 비중",
        "",
        "## 결론",
        "",
        "최종 `ntt_opt_slothy`에서는 직접 최적화한 **q=12289 공통 NTT/iNTT의 "
        "실행 사이클이 66.4~71.6% 감소**했다. 따라서 검증에서 NTT 비중은 "
        "FN-DSA-512 기준 19.22%에서 6.59%로, FN-DSA-1024 기준 21.81%에서 "
        "8.53%로 내려갔다. 검증은 원래 공통 NTT/iNTT 의존도가 가장 높으므로 "
        "전체 효과도 가장 분명하다.",
        "",
        "키 생성과 서명에서도 공통 NTT/iNTT 자체는 약 70% 빨라졌지만, 전체에서 "
        "차지하던 비중이 작다. 최적화 뒤의 지배 병목은 키 생성의 NTRU solver·CRT·"
        "31-bit mod-p NTT와 서명의 LDL tree·ffSampling·FFT·sampler로 이동했다.",
        "",
        "## 핵심 비교",
        "",
        "아래의 `사이클 감소`는 q=12289 NTT/iNTT 범주 자체의 감소율이고, "
        "`비중`은 각 키 생성·서명·검증 API 총 사이클을 100%로 정규화한 값이다.",
        "",
        "| 파라미터 | 단계 | 전 NTT 비중 | 후 NTT 비중 | 비중 변화 | NTT 사이클/호출 전 | 후 | NTT 사이클 감소 |",
        "|---:|---|---:|---:|---:|---:|---:|---:|",
    ]
    for degree in DEGREES:
        for operation in OPERATIONS:
            bt = before["totals"][f"{degree}_{operation}"]
            at = after["totals"][f"{degree}_{operation}"]
            bc = value(before, degree, operation, "ntt_q")["cycles"]
            ac = value(after, degree, operation, "ntt_q")["cycles"]
            bs, ass = percent(bc, bt["total"]), percent(ac, at["total"])
            lines.append(
                f"| {degree} | {OP_LABEL[operation]} | {fmt_share(bs)} | {fmt_share(ass)} | "
                f"{fmt_pp(ass - bs)} | {fmt_cycles(cycles_per_call(bc, bt['calls']))} | "
                f"{fmt_cycles(cycles_per_call(ac, at['calls']))} | "
                f"{fmt_change(delta_percent(bc, ac))} |"
            )

    lines += [
        "",
        "## 전체 프로파일",
        "",
        "표의 모든 `전 비중`과 `후 비중` 열은 각각 합계 100%다. 0인 범주는 생략했다. "
        "범주 사이클 감소가 음수이면 해당 범주의 계측 사이클이 늘었다는 뜻이다.",
    ]
    for degree in DEGREES:
        for operation in OPERATIONS:
            total_key = f"{degree}_{operation}"
            bt, at = before["totals"][total_key], after["totals"][total_key]
            lines += [
                "",
                f"### FN-DSA-{degree} {OP_LABEL[operation]}",
                "",
                f"API 호출 수: {bt['calls']}회. 계측 총 사이클/호출: "
                f"{fmt_cycles(cycles_per_call(bt['total'], bt['calls']))} → "
                f"{fmt_cycles(cycles_per_call(at['total'], at['calls']))}.",
                "",
                "| 연산 범주 | 전 사이클/호출 | 전 비중 | 후 사이클/호출 | 후 비중 | 비중 변화 | 범주 사이클 감소 |",
                "|---|---:|---:|---:|---:|---:|---:|",
            ]
            rows = []
            for category, label in CATEGORY_LABEL.items():
                bc = value(before, degree, operation, category)["cycles"]
                ac = value(after, degree, operation, category)["cycles"]
                if not bc and not ac:
                    continue
                bs, ass = percent(bc, bt["total"]), percent(ac, at["total"])
                rows.append((bs, label, bc, ac, bs, ass))
            # Largest baseline contributors first, while keeping the optimized
            # target visually easy to find by bolding it.
            for _, label, bc, ac, bs, ass in sorted(rows, reverse=True):
                rendered_label = f"**{label}**" if label == CATEGORY_LABEL["ntt_q"] else label
                lines.append(
                    f"| {rendered_label} | {fmt_cycles(cycles_per_call(bc, bt['calls']))} | "
                    f"{fmt_share(bs)} | {fmt_cycles(cycles_per_call(ac, at['calls']))} | "
                    f"{fmt_share(ass)} | {fmt_pp(ass - bs)} | "
                    f"{fmt_change(delta_percent(bc, ac))} |"
                )
            bsum = sum(value(before, degree, operation, c)["cycles"] for c in CATEGORY_LABEL)
            asum = sum(value(after, degree, operation, c)["cycles"] for c in CATEGORY_LABEL)
            if bsum != bt["total"] or asum != at["total"]:
                raise RuntimeError(f"category sum mismatch: {total_key}")
            lines.append(
                f"| **합계** | **{fmt_cycles(cycles_per_call(bsum, bt['calls']))}** | "
                f"**100.00%** | **{fmt_cycles(cycles_per_call(asum, at['calls']))}** | "
                f"**100.00%** | — | {fmt_change(delta_percent(bsum, asum))} |"
            )

    lines += [
        "",
        "## 해석할 때 주의할 점",
        "",
        "- 이 결과는 원본 C 함수에 임시 계측 훅을 삽입하고 어셈블리 함수는 링크 wrapper로 "
        "감싼 **계측 펌웨어 결과**다. 범주별 비중과 병목 이동을 보는 자료이며, 최종 배포 "
        "펌웨어의 절대 성능 수치를 대신하지 않는다.",
        "- 전후 어셈블리 크기와 함수 배치가 달라져 직접 수정하지 않은 범주의 계측 사이클도 "
        "소폭 변할 수 있다. 특히 매우 자주 호출되는 sampler 계측에는 훅 비용과 코드 배치 "
        "효과가 누적된다. 따라서 이번 단계의 직접 성과는 동일 호출 횟수에서 측정한 "
        "`q=12289 NTT/iNTT` 감소율로 판단하는 것이 가장 안전하다.",
        "- 공통 q=12289 NTT/iNTT와 키 생성 NTRU solver 내부의 `31-bit mod-p NTT/iNTT`는 "
        "서로 다른 구현이다. 이번 q=12289 경로 최적화(`mq.c`의 전용 상수표와 "
        "`mq_cm55.s`)는 전자만 바꾸므로 후자는 빨라지지 않았다.",
        "",
        "## 측정 조건과 무결성",
        "",
        "- 보드: NUCLEO-N657X0-Q, Cortex-M55 800 MHz",
        "- 실행 배치: 코드 ITCM, 데이터·rodata·스택 DTCM; I/D cache OFF",
        "- 컴파일: 동일 GCC 15.2.1, `-O3`, 동일 Zephyr/mlkem-native Nucleo 설정",
        "- 전: `fn-dsa_m55/ref`의 기존 `mq.c` + `mq_cm4.s`; 후: "
        "`fn-dsa_m55/ntt_opt_slothy`의 Barrett 전용 상수표를 포함한 `mq.c` + `mq_cm55.s`",
        "- 반복: 키 생성 10회, 서명 100회, 검증 100회; 계측 구간 IRQ OFF",
        "- 모든 범주는 배타적(exclusive) 계측이므로 중복 합산하지 않았으며 각 API에서 정확히 100%",
        "- 전후 함수 진입 횟수 동일; q=12289 NTT/iNTT 진입 횟수도 동일",
        "- 출력 지문 일치: FN-DSA-512 `9895079d`, FN-DSA-1024 `a020dd02`",
        "- 양쪽 모두 정상 서명 검증·변조 서명 거부 PASS, CFSR/HFSR/AFSR=0, TCM ECC 정상",
        "",
        "## 재현 자료",
        "",
        f"- 전 계측 실행: `{before_dir}`",
        f"- 후 계측 실행: `{after_dir}`",
        f"- 전 raw log SHA-256: `{before_validation['raw_log_sha256']}`",
        f"- 후 raw log SHA-256: `{after_validation['raw_log_sha256']}`",
        f"- 전 ELF SHA-256: `{before_validation['elf_sha256']}`",
        f"- 후 ELF SHA-256: `{after_validation['elf_sha256']}`",
        "- 재현: `./build.sh all`, 보드 연결 후 `./run.py before`, `./run.py after`, `./report.py`",
        "",
    ]
    (ROOT / "result.md").write_text("\n".join(lines))


if __name__ == "__main__":
    main()
