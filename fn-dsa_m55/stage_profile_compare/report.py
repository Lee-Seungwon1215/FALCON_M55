#!/usr/bin/env python3
"""Generate the algorithm-stage before/after share report."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
DEGREES = (512, 1024)
OPERATIONS = ("keygen", "sign", "verify")
OP_LABEL = {"keygen": "키 생성", "sign": "서명", "verify": "검증"}
CATEGORIES = [
	"other",
	"kg_generate", "kg_check", "kg_ntru", "kg_sk_complete", "kg_pk_compute",
	"sg_message_hash", "sg_key_prep", "sg_hash_to_point", "sg_fft_basis",
	"sg_ldl_ffsampling", "sg_gaussian_berexp", "sg_recon_norm", "sg_encode",
	"vr_message_hash", "vr_decode", "vr_ntt", "vr_hash_to_point", "vr_poly", "vr_norm",
]
PHASES = {
	"keygen": [
		("other", "API 준비·기타"),
		("kg_generate", "SK 후보 생성: Gaussian으로 f,g 생성"),
		("kg_check", "SK 후보 검사: f 가역성·크기·직교노름"),
		("kg_ntru", "SK 핵심값 계산: NTRU solve"),
		("kg_sk_complete", "SK 완성·인코딩: f,g,F"),
		("kg_pk_compute", "PK 계산·인코딩·해시: h=g/f"),
	],
	"sign": [
		("other", "API 검사·기타"),
		("sg_message_hash", "메시지·공개키 해시: mu 계산"),
		("sg_key_prep", "키 준비: SK decode·G 복원·seed 파생"),
		("sg_hash_to_point", "nonce 생성·Hash-to-Point"),
		("sg_fft_basis", "FFT basis·Gram·target 준비"),
		("sg_ldl_ffsampling", "LDL·ffSampling 진행 (sampler 제외)"),
		("sg_gaussian_berexp", "Gaussian·BerExp sampler"),
		("sg_recon_norm", "서명벡터 복원·q-NTT·노름 검사"),
		("sg_encode", "서명 인코딩·완료"),
	],
	"verify": [
		("other", "API·헤더 검사·기타"),
		("vr_message_hash", "메시지·공개키 해시: mu 계산"),
		("vr_decode", "PK·서명 디코딩"),
		("vr_ntt", "q-NTT·다항식 곱·iNTT"),
		("vr_hash_to_point", "Hash-to-Point"),
		("vr_poly", "s1 다항식 계산"),
		("vr_norm", "s1,s2 노름·최종 판정"),
	],
}


def sha256(path: Path) -> str:
	return hashlib.sha256(path.read_bytes()).hexdigest()


def load(candidate: str) -> tuple[dict, dict, Path]:
	validated = json.loads((ROOT / "results" / candidate / "validated.json").read_text())
	if not validated.get("valid"):
		raise RuntimeError(f"candidate is not validated: {candidate}")
	run_dir = Path(validated["run_directory"])
	run = json.loads((run_dir / "run.json").read_text())
	if not run.get("valid") or run.get("validation_errors"):
		raise RuntimeError(f"invalid run: {run_dir}")
	if sha256(run_dir / "raw.log") != validated["raw_log_sha256"]:
		raise RuntimeError(f"raw log changed: {run_dir}")
	return validated, run, run_dir


def category(run: dict, degree: int, operation: str, name: str) -> dict:
	return run["categories"][f"{degree}_{operation}_{name}"]


def share(cycles: int, total: int) -> float:
	return cycles * 100.0 / total


def change(before: int, after: int) -> float:
	return (before - after) * 100.0 / before if before else 0.0


def fmt_cycles(value: float) -> str:
	return f"{value:,.0f}"


def main() -> None:
	bv, before, before_dir = load("before")
	av, after, after_dir = load("after")
	if before["fingerprints"] != after["fingerprints"]:
		raise RuntimeError("output fingerprints differ")
	for degree in DEGREES:
		for operation in OPERATIONS:
			bt = before["totals"][f"{degree}_{operation}"]
			at = after["totals"][f"{degree}_{operation}"]
			if bt["calls"] != at["calls"]:
				raise RuntimeError("API call counts differ")
			for name in CATEGORIES:
				if category(before, degree, operation, name)["entries"] != category(after, degree, operation, name)["entries"]:
					raise RuntimeError(f"phase path differs: {degree} {operation} {name}")

	lines = [
		"# FN-DSA M55 알고리즘 단계별 비중: 최적화 전·후",
		"",
		"각 키 생성·서명·검증 API의 총 사이클을 각각 100%로 두고, 실제 코드가 "
		"진행하는 상위 알고리즘 단계별 배타적 비중을 비교했다.",
		"",
		"## 비중 비교",
	]
	for operation in OPERATIONS:
		lines += [
			"",
			f"### {OP_LABEL[operation]}",
			"",
			"| 실제 구현 단계 | 512 전 | 512 후 | 변화 | 1024 전 | 1024 후 | 변화 |",
			"|---|---:|---:|---:|---:|---:|---:|",
		]
		for name, label in PHASES[operation]:
			values = []
			for degree in DEGREES:
				bt = before["totals"][f"{degree}_{operation}"]["total"]
				at = after["totals"][f"{degree}_{operation}"]["total"]
				bs = share(category(before, degree, operation, name)["cycles"], bt)
				ass = share(category(after, degree, operation, name)["cycles"], at)
				values += [f"{bs:.2f}%", f"{ass:.2f}%", f"{ass-bs:+.2f} pp"]
			lines.append(f"| {label} | " + " | ".join(values) + " |")
		lines.append("| **합계** | **100.00%** | **100.00%** | — | **100.00%** | **100.00%** | — |")

	lines += ["", "## 사이클과 단계별 개선율"]
	for degree in DEGREES:
		for operation in OPERATIONS:
			bt = before["totals"][f"{degree}_{operation}"]
			at = after["totals"][f"{degree}_{operation}"]
			lines += [
				"",
				f"### FN-DSA-{degree} {OP_LABEL[operation]}",
				"",
				f"호출 수 {bt['calls']}회. 계측 총 사이클/호출 "
				f"{fmt_cycles(bt['total']/bt['calls'])} → {fmt_cycles(at['total']/at['calls'])}.",
				"",
				"| 실제 구현 단계 | 전 cycles/call | 후 cycles/call | 단계 사이클 감소율 |",
				"|---|---:|---:|---:|",
			]
			for name, label in PHASES[operation]:
				bc = category(before, degree, operation, name)["cycles"]
				ac = category(after, degree, operation, name)["cycles"]
				lines.append(f"| {label} | {fmt_cycles(bc/bt['calls'])} | "
					f"{fmt_cycles(ac/at['calls'])} | {change(bc, ac):+.2f}% |")

	lines += [
		"",
		"## 단계 경계 해석",
		"",
		"- 현재 compact signing-key `c-fn-dsa`는 키 생성 결과에 FFT tree를 저장하지 않는다. "
		"키 생성의 fixed-point FFT는 후보 직교노름 검사와 NTRU solve 내부에서 실행되므로 "
		"각 상위 단계에 포함했다. FFT basis·Gram과 LDL/ffSampling은 서명 때 다시 계산한다.",
		"- 서명의 Gaussian/BerExp는 LDL/ffSampling 뒤에 독립적으로 실행되는 단계가 아니라 "
		"ffSampling이 반복 호출하는 내부 sampler다. 표에서는 중첩 시간을 sampler로 빼고 "
		"남은 시간을 `LDL·ffSampling 진행`에 배타적으로 배정했다.",
		"- 검증의 실제 실행 순서는 메시지 해시 → decode/`norm2` → q-NTT 곱/iNTT → "
		"Hash-to-Point → s1 계산/`norm1`이다. 두 노름 계산은 `노름·최종 판정` 한 행으로 합쳤다.",
		"",
		"## 측정 조건·검증",
		"",
		"- 전: `fn-dsa_m55/ref`; 후: `fn-dsa_m55/ntt_opt_slothy`",
		"- NUCLEO-N657X0-Q Cortex-M55 800 MHz, 코드 ITCM, 데이터·rodata·스택 DTCM, I/D cache OFF",
		"- GCC 15.2.1, `-O3`, 동일 Zephyr/mlkem-native Nucleo 설정, 실제 어셈블리 활성화",
		"- 키 생성 10회, 서명 100회, 검증 100회; 동일 결정적 입력, 계측 구간 IRQ OFF",
		"- 단계별 배타적 사이클 합은 각 API 총 사이클과 정수 단위로 일치하여 정확히 100%",
		"- 전후 모든 단계 진입 횟수 동일",
		"- 전후 출력 지문 일치, 정상 검증·변조 거부 PASS, CFSR/HFSR/AFSR=0, TCM ECC ON",
		"- 단계 전환 훅은 상위 경계에만 넣었다. Gaussian/BerExp만 중첩 구조를 분리하려고 "
		"`sampler_next()`에 훅을 넣었으므로 이 행에는 반복 훅 비용이 포함된다.",
		"",
		"## 재현 자료",
		"",
		f"- 전 실행: `{before_dir}`",
		f"- 후 실행: `{after_dir}`",
		f"- 전 raw log SHA-256: `{bv['raw_log_sha256']}`",
		f"- 후 raw log SHA-256: `{av['raw_log_sha256']}`",
		"- 재현: `./build.sh all`, `./run.py before`, `./run.py after`, `./report.py`",
		"",
	]
	(ROOT / "result.md").write_text("\n".join(lines))


if __name__ == "__main__":
	main()
