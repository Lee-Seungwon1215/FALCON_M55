#!/usr/bin/env python3
"""Generate the per-logn mp_NTT/mp_iNTT profiling report."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
DEGREES = (512, 1024)
DIRECTIONS = (("forward", "mp_NTT"), ("inverse", "mp_iNTT"))


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


def entry(run: dict, degree: int, direction: str, logn: int) -> dict:
	return run["ntt_logn"][f"{degree}_{direction}_{logn}"]


def fmt(value: float) -> str:
	return f"{value:,.1f}"


def main() -> None:
	cv, control, control_dir = load("control")
	lv, measured, measured_dir = load("logn")
	if control["fingerprints"] != measured["fingerprints"]:
		raise RuntimeError("control/logn fingerprints differ")

	lines = [
		"# FN-DSA M55 NTRU `mp_NTT`/`mp_iNTT` logn별 프로파일",
		"",
		"`fn-dsa_m55/ntt_opt_slothy`의 `solve_NTRU()` 실행 중 호출된 31-bit "
		"RNS `mp_NTT()`와 `mp_iNTT()`만 `logn`별로 집계했다. 각 방향의 비중표는 "
		"독립적으로 100%가 된다.",
	]

	for degree in DEGREES:
		total = measured["totals"][str(degree)]
		control_total = control["totals"][str(degree)]
		calls = total["calls"]
		maximum_logn = 9 if degree == 512 else 10
		lines += [
			"",
			f"## FN-DSA-{degree}",
			"",
			f"- `solve_NTRU()` 호출: {calls}회",
			f"- logn 계측 NTRU: {fmt(total['total']/calls)} cycles/call",
			f"- 최소 훅 control: {fmt(control_total['total']/control_total['calls'])} "
			f"cycles/call; 관측 차이 "
			f"{(total['total']/calls)/(control_total['total']/control_total['calls'])*100-100:+.2f}%",
		]

		for direction, label in DIRECTIONS:
			direction_total = sum(entry(measured, degree, direction, logn)["cycles"]
				for logn in range(maximum_logn + 1))
			lines += [
				"",
				f"### {label} 내부 비중 — 합계 100%",
				"",
				"| logn | 변환 크기 | cycles/NTRU call | 호출/NTRU call | "
				"cycles/transform | 방향 내부 비중 | NTRU 전체 비중 |",
				"|---:|---:|---:|---:|---:|---:|---:|",
			]
			for logn in range(0, maximum_logn + 1):
				e = entry(measured, degree, direction, logn)
				per_transform = fmt(e['cycles']/e['entries']) if e['entries'] else "—"
				lines.append(
					f"| {logn} | {1 << logn} | {fmt(e['cycles']/calls)} | "
					f"{e['entries']/calls:.1f} | {per_transform} | "
					f"{100*e['cycles']/direction_total:.2f}% | "
					f"{100*e['cycles']/total['total']:.2f}% |")
			lines.append(
				f"| **합계** | — | **{fmt(direction_total/calls)}** | — | — | "
				"**100.00%** | "
				f"**{100*direction_total/total['total']:.2f}%** |")

		forward_total = sum(entry(measured, degree, "forward", logn)["cycles"]
			for logn in range(maximum_logn + 1))
		inverse_total = sum(entry(measured, degree, "inverse", logn)["cycles"]
			for logn in range(maximum_logn + 1))
		combined = forward_total + inverse_total
		lines += [
			"",
			"### Forward+inverse 통합",
			"",
			"| logn | 변환 크기 | cycles/NTRU call | NTT+iNTT 내부 비중 | "
			"NTRU 전체 비중 |",
			"|---:|---:|---:|---:|---:|",
		]
		for logn in range(0, maximum_logn + 1):
			value = (entry(measured, degree, "forward", logn)["cycles"]
				+ entry(measured, degree, "inverse", logn)["cycles"])
			lines.append(f"| {logn} | {1 << logn} | {fmt(value/calls)} | "
				f"{100*value/combined:.2f}% | {100*value/total['total']:.2f}% |")
		lines.append(f"| **합계** | — | **{fmt(combined/calls)}** | **100.00%** | "
			f"**{100*combined/total['total']:.2f}%** |")

	lines += [
		"",
		"## 측정 조건과 해석 범위",
		"",
		"- NUCLEO-N657X0-Q, Cortex-M55 800 MHz; 코드 ITCM, 데이터·스택 DTCM, "
		"I/D cache OFF, TCM ECC ON.",
		"- GCC 15.2.1, `-O3`, 크기별 결정적 키 생성 10회, 키 생성 측정 구간 IRQ OFF.",
		"- 각 NTT 함수 입·출구에서 DWT CYCCNT를 직접 읽었다. 표의 "
		"`cycles/transform`에는 두 번의 카운터 읽기와 계측 분기 비용이 포함되므로, "
		"특히 작은 `logn`의 절대 사이클은 순수 함수 시간보다 약간 크다.",
		"- 계측본과 control의 키 지문 일치, 정상 서명 검증·변조 거부 PASS, "
		"CFSR/HFSR/AFSR=0을 확인했다.",
		"",
		"## 재현 자료",
		"",
		f"- control 실행: `{control_dir}`",
		f"- logn 실행: `{measured_dir}`",
		f"- control raw log SHA-256: `{cv['raw_log_sha256']}`",
		f"- logn raw log SHA-256: `{lv['raw_log_sha256']}`",
		"- 재현: `./build.sh logn`, `./run.py logn`, `./report_logn.py`",
		"",
	]
	(ROOT / "ntt_logn_result.md").write_text("\n".join(lines))


if __name__ == "__main__":
	main()
