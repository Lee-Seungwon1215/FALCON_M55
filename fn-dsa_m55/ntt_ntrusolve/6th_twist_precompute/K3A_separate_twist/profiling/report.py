#!/usr/bin/env python3
"""Validate both board results and generate the comparison Markdown report."""
import json
from pathlib import Path

LABELS = {
    "other": "기타 / API",
    "shake": "SHAKE / Keccak-f 핵심 연산",
    "codec": "키·서명 인코딩/디코딩",
    "hash_to_point": "Hash-to-Point (SHAKE 제외)",
    "message_hash": "메시지 mu·공개키 해시 처리 (SHAKE 제외)",
    "fft_fixed": "FFT + iFFT (키 생성 고정소수점)",
    "fft_fpr": "FFT + iFFT (서명 FP64 정수 에뮬레이션)",
    "ntt_q": "q=12289 NTT + iNTT",
    "ntt_modp": "31비트 RNS NTT + iNTT 및 변환 테이블 생성",
    "keygen_other": "키 생성 선별·기타",
    "key_preparation": "서명 키 복원·준비 (하위 분류 제외)",
    "ntru_other": "NTRU solver 기타 (FFT/NTT/CRT 제외)",
    "crt": "CRT 재구성",
    "ldl_ffsampling": "LDL + ffSampling 진행·다항식 처리 (샘플러 등 제외)",
    "sampler_other": "서명 샘플러 기타 연산·PRNG 접근",
    "gaussian_fg": "Gaussian f,g 생성 (SHAKE 제외)",
    "gaussian0": "서명 Gaussian0 기본 샘플러",
    "berexp": "BerExp 거부 검사 (SHAKE 제외)",
    "norm": "Norm 검사·정규화 (별도 분류 연산 제외)",
    "sign_other": "서명 핵심 기타",
    "verify_other": "검증 핵심 기타",
}
OPS = {"keygen": "키 생성", "sign": "서명", "verify": "검증"}

def main():
    directory = Path(__file__).resolve().parent / "results"
    profiles = {t: json.loads((directory / f"{t}_profile.json").read_text()) for t in ["m4", "m55"]}
    plain = {t: json.loads((directory / f"{t}_uninstrumented.json").read_text()) for t in ["m4", "m55"]}
    all_runs = list(profiles.values()) + list(plain.values())
    assert len({r["fingerprint"] for r in all_runs}) == 1
    assert len({r["source_commit"] for r in all_runs}) == 1
    for r in all_runs:
        assert r["state"] == 0x600D0000 and r["error"] == r["profile_error"] == 0
        for name, count in zip(OPS, [10, 100, 100]):
            s = r["operations"][name]
            assert s["calls"] == count
            assert sum(c["cycles"] for c in s["categories"].values()) == s["total_cycles"]
    for name in OPS:
        assert {k: v["entries"] for k, v in profiles["m4"]["operations"][name]["categories"].items()} == {
            k: v["entries"] for k, v in profiles["m55"]["operations"][name]["categories"].items()}

    lines = ["# FN-DSA-512 참조 C 구현: M4 / M55 실측 프로파일", "",
        "이 결과는 연결된 두 보드의 DWT CYCCNT를 읽은 실제 측정이다. 호스트 실행시간이나 시뮬레이션 수치가 아니다.", "",
        "## 측정 조건", "",
        f"- 원본 커밋: `{profiles['m4']['source_commit']}`.",
        "- `fn-dsa_ref` 원본 C/헤더와 `fn-dsa_m4/ref`는 수정하지 않았다. 계측용 C 복사본은 `build/*/generated/`에서 생성한다.",
        "- **호환성 수정 1건:** 최신 `mq.c`가 `#if 0 /* obsolete */`로 제외한 `mqpoly_sqnorm_int_to_signed()`를 생성본에서 다시 활성화했다. `sign_core.c`가 여전히 호출하므로 이 수정 없이 순수 C 빌드는 링크되지 않는다. 함수 본문의 수식은 수정하지 않았다.",
        "- 컴파일러: Arm GNU Toolchain 15.3.Rel1 / GCC 15.3.1; `-O3 -fno-tree-vectorize -fno-strict-aliasing -ffp-contract=off`, LTO 없음.",
        "- `FNDSA_ASM_CORTEXM4=0`, AVX2/SSE2/NEON/RV64D 비활성화, `FNDSA_64=0`. FN-DSA 연산은 참조 C 경로이며 수동 M4 어셈블리나 MVE 최적화를 적용하지 않았다.",
        "- 키 생성은 64비트 고정소수점, 서명은 `uint64_t` 기반 FP64 소프트웨어 에뮬레이션이다. M55의 하드웨어 FP64로 교체한 결과가 아니다.",
        "- 워밍업 키 생성·서명·검증 1회 제외 후 키 생성 10회 / 서명 100회 / 검증 100회. 두 보드에서 동일한 입력 집합을 사용했다.",
        "- 두 보드에 동일한 결정적 시드를 사용했다. 키 생성은 서로 다른 시드 10개, 서명은 마지막 생성 키와 서로 다른 서명 시드 100개, 검증은 마지막 서명을 반복한다.",
        "- 공개 seeded/temp API 사용. 운영체제/실제 하드웨어 RNG 비용은 포함하지 않는다. 결정적 시드는 벤치마크 전용이며 보안용으로 사용하면 안 된다.",
        "- 측정 구간 인터럽트 비활성화. SRAM에 로드해서 실행했으며 내부/외부 Flash는 기록·삭제하지 않았다.", "",
        "| 설정 | M4 | M55 |", "|---|---|---|",
        "| 확인된 대상 | STM32L4R/L4S 계열, ID `0x470`, Flash 2 MiB | NUCLEO-N657X0-Q / STM32N657 |",
        f"| CPUID | `0x{profiles['m4']['cpuid']:08x}` | `0x{profiles['m55']['cpuid']:08x}` |",
        "| 공칭 CPU 클럭 | 120 MHz (MSI→PLL, 전압 range-1 boost) | 600 MHz (HSI→PLL, 기존 Falcon FSBL 설정) |",
        "| 코드 / 데이터 | SRAM1 / SRAM3 | AXI SRAM2 |",
        "| 캐시 | Flash I/D 캐시는 활성화되지만 코드·데이터는 SRAM이므로 그 캐시의 이득은 없음 | 코어 I-cache / D-cache 활성화 |",
        f"| 캐시 설정 레지스터 | FLASH_ACR=`0x{profiles['m4']['cache_control']:08x}` | SCB_CCR=`0x{profiles['m55']['cache_control']:08x}` |",
        "| 아키텍처 옵션 | `-mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb` | `-mcpu=cortex-m55 -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -mcmse` |", "",
        "M4의 정확한 보드명·R/S 세부 모델은 디바이스 ID만으로 확정하지 않았다. 논문의 STM32F407, 24 MHz, GCC 13.2.1, -O2, 어셈블리 활성화 조건과 다르며 **논문 수치 재현 결과가 아니다.**", "",
        "## 전체 사이클: 계측 빌드", "",
        "아래 평균에는 계측 훅의 비용과 그에 따른 컴파일 결과 변화가 포함된다.", "",
        "| 단계 | M4 cycles/call | M4 ms/call | M55 cycles/call | M55 ms/call |", "|---|---:|---:|---:|---:|"]
    for op, label in OPS.items():
        averages = [profiles[t]["operations"][op]["total_cycles"] / profiles[t]["operations"][op]["calls"] for t in ["m4", "m55"]]
        times = [avg * 1000 / profiles[t]["core_clock_hz"] for avg, t in zip(averages, ["m4", "m55"])]
        lines.append(f"| {label} | {averages[0]:,.1f} | {times[0]:.3f} | {averages[1]:,.1f} | {times[1]:.3f} |")
    lines += ["", "## 연산 비중 (단계마다 100%)", "",
        "배타적 집계: 중첩 호출은 가장 안쪽 분류에만 부과한다. SHAKE/Keccak-f를 모든 호출 위치에서 독립 분류하므로, Hash-to-Point·Gaussian·NTRU 등은 그 SHAKE 시간을 중복 포함하지 않는다.", "",
        "기존 Falcon 보고서는 SHAKE를 Hash-to-Point 등 상위 항목에 포함한 곳이 있으므로, 서로 다른 보고서의 같은 이름만 보고 비율을 직접 비교하지 말아야 한다.", ""]
    for op, label in OPS.items():
        lines += [f"### {label}", "", "| 배타적 연산 분류 | M4 cycles/call | M4 비중 | M55 cycles/call | M55 비중 |", "|---|---:|---:|---:|---:|"]
        for cat, catlabel in LABELS.items():
            s4, s55 = [profiles[t]["operations"][op] for t in ["m4", "m55"]]
            a, b = [s["categories"][cat]["cycles"] for s in [s4, s55]]
            if not a and not b: continue
            lines.append(f"| {catlabel} | {a/s4['calls']:,.1f} | {100*a/s4['total_cycles']:.4f}% | {b/s55['calls']:,.1f} | {100*b/s55['total_cycles']:.4f}% |")
        lines += ["| 합계 | — | **100%** | — | **100%** |", ""]
    lines += ["## 계측 훅을 끈 비교 실행", "",
        "동일 시드·동일 API·동일 컴파일 옵션에서 계측 훅만 비활성화했다. API 양끝의 DWT 타이머는 유지한다. 별도의 빌드이므로 아래 차이는 훅 호출 비용뿐 아니라 인라이닝·코드 배치 변화도 포함한다.", "",
        "| 단계 | M4 훅 OFF cycles/call | M4 계측 ON 증가율 | M55 훅 OFF cycles/call | M55 계측 ON 증가율 |", "|---|---:|---:|---:|---:|"]
    for op, label in OPS.items():
        values = []
        for t in ["m4", "m55"]:
            a, b = profiles[t]["operations"][op], plain[t]["operations"][op]
            avg = b["total_cycles"] / b["calls"]
            overhead = 100 * ((a["total_cycles"] / a["calls"]) / avg - 1)
            values += [f"{avg:,.1f}", f"{overhead:+.2f}%"]
        lines.append("| " + " | ".join([label] + values) + " |")
    lines += ["", "## 검증·재현 자료", "",
        "- 호스트 참조 C의 전체 업스트림 테스트(FFT/fpr/sampler/keygen/verify/self/KAT 포함) 통과.",
        "- 두 보드에서 워밍업 서명 검증, 변조 서명 거부, 측정한 서명 100개 각각의 검증 통과. 서명 후 검증은 서명 측정 구간 밖에서 수행했다.",
        "- 모든 보드 실행에서 state=`0x600d0000`, error=0, profile_error=0.",
        f"- 호스트 계측 ON/OFF와 두 보드 계측 ON/OFF의 생성물 누적 FNV-1a 체크섬: `0x{profiles['m4']['fingerprint']:08x}`. 체크섬은 진단용이며 암호학적 동등성 증명은 아니다.",
        "- M4/M55에서 각 분류 진입 횟수 동일. 모든 단계에서 정수 사이클 원시값의 합이 총 사이클과 정확히 일치함을 자동 확인했다. 표시 반올림으로 백분율 합계는 마지막 소수 자릿수에서 차이 날 수 있다.",
        "- 원시 자료: [M4 프로파일](m4_profile.json), [M55 프로파일](m55_profile.json), [M4 훅 OFF](m4_uninstrumented.json), [M55 훅 OFF](m55_uninstrumented.json). 각 파일에 합계·최소·최대·분류별 사이클·진입 횟수를 보존했다.",
        "- 빌드 재현: [프로파일러 README](../README.md), [함수 분류·호환성 수정](../instrument.py).", ""]
    (directory / "m4_m55_fndsa512_reference.md").write_text("\n".join(lines))
    print("Validated all four hardware runs; wrote", directory / "m4_m55_fndsa512_reference.md")

if __name__ == "__main__":
    main()
