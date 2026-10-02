#!/usr/bin/env python3
"""Generate the NTRU-solver internal 100% profiling report."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
DEGREES = (512, 1024)
PHASES = [
	("orchestration", "solve 제어·최종 F,G 변환"),
	("deepest", "deepest: resultant·CRT·Bezout로 최초 해 계산"),
	("intermediate", "intermediate 전체: 재귀 lifting·Babai reduction"),
	("depth0", "depth0: 최상위 정밀 reduction·F,G 완성"),
]
KERNELS = [
	("mp_ntt", "31-bit mod-p forward NTT"),
	("mp_intt", "31-bit mod-p inverse NTT"),
	("twiddle", "NTT/iNTT twiddle 표 생성"),
	("crt", "RNS → 큰 정수 CRT 재구성"),
	("bezout", "deepest binary GCD·Bezout"),
	("fft", "fixed-point forward FFT"),
	("ifft", "fixed-point inverse FFT"),
	("fxp_spectral", "FFT-domain fixed-point 곱셈·나눗셈"),
	("fixed_convert", "큰 정수 → fixed-point 근사 변환"),
	("sub_ntt", "NTT 기반 Babai scaled subtraction 나머지"),
	("sub_depth1", "depth-1 전용 scaled subtraction 나머지"),
	("sub_plain", "일반 정수 scaled subtraction"),
	("other", "RNS 변환·lifting 점별연산·복사·제어 등 기타"),
]


def sha(path: Path) -> str:
	return hashlib.sha256(path.read_bytes()).hexdigest()


def load(candidate: str) -> tuple[dict, dict, Path]:
	validated = json.loads((ROOT / "results" / candidate / "validated.json").read_text())
	if not validated.get("valid"):
		raise RuntimeError(f"not validated: {candidate}")
	run_dir = Path(validated["run_directory"])
	run = json.loads((run_dir / "run.json").read_text())
	if not run.get("valid") or run.get("validation_errors"):
		raise RuntimeError(f"invalid run: {run_dir}")
	if sha(run_dir / "raw.log") != validated["raw_log_sha256"]:
		raise RuntimeError(f"raw log changed: {run_dir}")
	return validated, run, run_dir


def phase(run: dict, degree: int, name: str) -> dict:
	return run["phases"][f"{degree}_{name}"]


def kernel(run: dict, degree: int, name: str) -> dict:
	return run["kernels"][f"{degree}_{name}"]


def fmt(value: float) -> str:
	return f"{value:,.0f}"


def pct(value: int, total: int) -> str:
	return f"{100.0 * value / total:.2f}%"


def main() -> None:
	cv, control, control_dir = load("control")
	dv, detailed, detailed_dir = load("detailed")
	if control["fingerprints"] != detailed["fingerprints"]:
		raise RuntimeError("control/detailed fingerprints differ")
	for degree in DEGREES:
		if control["totals"][str(degree)]["calls"] != detailed["totals"][str(degree)]["calls"]:
			raise RuntimeError(f"NTRU call count differs: {degree}")

	lines = [
		"# FN-DSA M55 NTRU solve 내부 100% 프로파일",
		"",
		"`fn-dsa_m55/ntt_opt_slothy`를 기준으로 `solve_NTRU()`에 들어간 순간부터 "
		"반환할 때까지의 누적 사이클만 분모로 사용했다. 키 후보 생성·검사와 공개키 계산은 "
		"분모에 포함하지 않았다.",
		"",
		"재귀 단계 표와 연산 커널 표는 동일한 실행 시간을 서로 다른 관점에서 분류하므로, "
		"각 표가 독립적으로 정확히 100%가 된다.",
	]

	for degree in DEGREES:
		t = detailed["totals"][str(degree)]
		ct = control["totals"][str(degree)]
		calls = t["calls"]
		intermediate_cycles = sum(phase(detailed, degree, f"intermediate_d{i}")["cycles"]
			for i in range(1, 10))
		phase_values = {
			"orchestration": phase(detailed, degree, "orchestration")["cycles"],
			"deepest": phase(detailed, degree, "deepest")["cycles"],
			"intermediate": intermediate_cycles,
			"depth0": phase(detailed, degree, "depth0")["cycles"],
		}
		if sum(phase_values.values()) != t["total"]:
			raise RuntimeError(f"aggregated phase sum mismatch: {degree}")

		lines += [
			"",
			f"## FN-DSA-{degree}",
			"",
			f"- 키 생성 10회에서 `solve_NTRU()` 호출 {calls}회",
			f"- 상세 계측 NTRU 사이클: 호출당 평균 {fmt(t['total']/calls)} cycles",
			f"- 최소/최대: {fmt(t['minimum'])} / {fmt(t['maximum'])} cycles",
			f"- 최소 훅 control: 호출당 {fmt(ct['total']/ct['calls'])} cycles; "
			f"상세 훅에 따른 관측 차이 {(t['total']/calls)/(ct['total']/ct['calls'])*100-100:+.2f}%",
			"",
			"### 재귀 단계 기준 — 합계 100%",
			"",
			"| 단계 | cycles/NTRU call | 비중 |",
			"|---|---:|---:|",
		]
		for name, label in PHASES:
			value = phase_values[name]
			lines.append(f"| {label} | {fmt(value/calls)} | {pct(value, t['total'])} |")
		lines.append(f"| **합계** | **{fmt(t['total']/calls)}** | **100.00%** |")

		lines += [
			"",
			"#### intermediate 재귀 깊이 상세",
			"",
			"| depth | 다항식 차수 | cycles/NTRU call | NTRU 전체 비중 |",
			"|---:|---:|---:|---:|",
		]
		logn_top = 9 if degree == 512 else 10
		for depth in range(1, logn_top):
			value = phase(detailed, degree, f"intermediate_d{depth}")["cycles"]
			lines.append(f"| {depth} | {1 << (logn_top-depth)} | "
				f"{fmt(value/calls)} | {pct(value, t['total'])} |")

		lines += [
			"",
			"### 연산 커널 기준 — 합계 100%",
			"",
			"| 배타적 연산 범주 | cycles/NTRU call | 비중 | 진입/NTRU call |",
			"|---|---:|---:|---:|",
		]
		for name, label in KERNELS:
			entry = kernel(detailed, degree, name)
			lines.append(f"| {label} | {fmt(entry['cycles']/calls)} | "
				f"{pct(entry['cycles'], t['total'])} | {entry['entries']/calls:.1f} |")
		lines.append(f"| **합계** | **{fmt(t['total']/calls)}** | **100.00%** | — |")

		ntt = kernel(detailed, degree, "mp_ntt")["cycles"]
		intt = kernel(detailed, degree, "mp_intt")["cycles"]
		twiddle = kernel(detailed, degree, "twiddle")["cycles"]
		lines += [
			"",
			f"**핵심:** 순수 `mp_NTT + mp_iNTT`는 NTRU solve의 "
			f"**{100*(ntt+intt)/t['total']:.2f}%**다. twiddle 표 생성까지 포함한 "
			f"NTT 지원 경로는 **{100*(ntt+intt+twiddle)/t['total']:.2f}%**다.",
		]

	lines += [
		"",
		"## 측정·검증 조건",
		"",
		"- 소스: `fn-dsa_m55/ntt_opt_slothy` (`mq_cm55.s` 직접 사용)",
		"- 보드: NUCLEO-N657X0-Q Cortex-M55 800 MHz",
		"- 코드 ITCM, 데이터·rodata·스택 DTCM, I/D cache OFF, TCM ECC ON",
		"- GCC 15.2.1, `-O3`, mlkem-native Nucleo 설정",
		"- 파라미터별 키 생성 10회, 동일 결정적 seed, 키 생성 구간 IRQ OFF",
		"- 상세/control 출력 지문 일치, 정상 서명 검증·변조 거부 PASS, CFSR/HFSR/AFSR=0",
		"- 커널 범주는 중첩 호출 시 가장 안쪽 범주에만 시간을 배정했다. 예를 들어 "
		"`poly_sub_scaled_ntt()` 안에서 호출된 `mp_NTT()` 시간은 `sub_ntt`가 아니라 "
		"`mp_ntt`에만 들어간다.",
		"- control은 `solve_NTRU()` 시작/종료 타이머만 유지한 펌웨어다. 상세/control 차이는 "
		"훅 비용뿐 아니라 계측에 따른 코드 배치 변화도 포함하므로 보정값으로 빼지 않았다.",
		"",
		"## 재현 자료",
		"",
		f"- control 실행: `{control_dir}`",
		f"- detailed 실행: `{detailed_dir}`",
		f"- control raw log SHA-256: `{cv['raw_log_sha256']}`",
		f"- detailed raw log SHA-256: `{dv['raw_log_sha256']}`",
		"- 재현: `./build.sh all`, `./run.py control`, `./run.py detailed`, `./report.py`",
		"",
	]
	(ROOT / "result.md").write_text("\n".join(lines))


if __name__ == "__main__":
	main()
