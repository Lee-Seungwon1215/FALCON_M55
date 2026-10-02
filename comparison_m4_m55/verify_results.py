#!/usr/bin/env python3
"""Offline independent recomputation of both raw mailboxes, then comparison."""
import argparse
import hashlib
import json
from pathlib import Path
import statistics
import struct
import subprocess
import sys
import tempfile
import time
import controller

ROOT = Path(__file__).resolve().parent
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def validate_one(board):
    c = controller.Controller(board)
    session = json.loads((c.out / "session.json").read_text())
    recorded = json.loads((c.out / "results.json").read_text())
    raw = (c.logs / "mailbox.bin").read_bytes()
    assert len(raw) == 7600
    words = list(struct.unpack("<1900I", raw))
    h = controller.parse_header(words)
    controller.validate(h, board)
    assert h == recorded["header"] and h["state"] == controller.DONE
    assert h["counts"] == [[100]*3, [100]*3]
    oracle = json.loads((ROOT / "build/host_oracle.json").read_text())
    for k in ["warmup_fingerprint", "fingerprint", "warmup_digest", "output_digest"]:
        assert h[k] == oracle[k] == session["host_oracle"][k]
    for name, expected in session["harness_hashes"].items():
        assert sha(ROOT / name) == expected, "Harness modified during run: " + name
    assert sha(c.build / "firmware.bin") == session["firmware"]["binary_sha256"]
    assert sha(c.build / "firmware.elf") == session["firmware"]["elf_sha256"]
    assert c.source_audit() == session["source_hashes"]
    c.firmware_audit()
    all_cycles = struct.unpack_from("<600Q", raw, 400)
    all_us = struct.unpack_from("<600I", raw, 5200)
    max_error = 0
    for d, item in enumerate(recorded["measurements"]):
        assert item["degree"] == 512 << d
        for op, name in enumerate(["keygen", "sign", "verify"]):
            offset = (d*3+op)*100
            values = list(all_cycles[offset:offset+100]); us = list(all_us[offset:offset+100])
            result = item["operations"][name]
            assert values == result["cycles"] and us == result["microseconds"]
            expected = dict(count=100, mean=statistics.mean(values), median=statistics.median(values),
                stdev=statistics.stdev(values), min=min(values), max=max(values))
            for key, value in expected.items(): assert result[key] == value, (board, name, key)
            for cycles, micro in zip(values, us):
                low = cycles & 0xFFFFFFFF
                inferred_wraps = (micro*24 + 2**31 - low) >> 32
                assert cycles == (inferred_wraps << 32) | low
                error = abs(cycles - micro*24); assert error <= 4096
                max_error = max(max_error, error)
    assert max_error <= h["max_timer_error_cycles"] <= 4096
    if board == "m4": assert session["flash_unchanged_verified"]
    audit = dict(samples=len(all_cycles), raw_sha256=sha(c.logs / "mailbox.bin"),
        max_timer_error_cycles=max_error, recovered_dwt_wraps=sum(n >> 32 for n in all_cycles),
        output_digest_hex=[struct.pack("<8I", *row).hex() for row in h["output_digest"]],
        firmware_sha256=session["firmware"]["elf_sha256"], source_manifest_verified=True,
        harness_manifest_verified=True, statistics_recomputed=True, passed=True)
    return recorded, session, audit

def preflight():
    evidence = {}
    compiler = Path("/private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-gcc")
    version = subprocess.check_output([str(compiler), "--version"], text=True).splitlines()[0]
    assert "13.2.1" in version
    for board in ["m4", "m55"]:
        c = controller.Controller(board)
        c.source_audit(); sp, entry, info = c.firmware_audit()
        log = (c.out / "build.log").read_text()
        assert "-O3" in log and "-ffp-contract=off" in log
        assert "-ffast-math" not in log and "-flto" not in log
        assert "error:" not in log and "warning:" not in log
        evidence[board] = dict(sp=sp, entry=entry, binary_bytes=info["binary_bytes"],
            elf_sha256=info["elf_sha256"], source_manifest_verified=True)
    # Confirm the five supplied assembly implementations emit the same
    # unlinked instruction bytes under both target flag sets.
    same = {}
    flags = {
        "m4": ["-mthumb", "-mcpu=cortex-m4", "-mfpu=fpv4-sp-d16", "-mfloat-abi=hard"],
        "m55": ["-mthumb", "-mcpu=cortex-m55+nomve", "-mfpu=auto", "-mfloat-abi=hard", "-mcmse"]}
    with tempfile.TemporaryDirectory(prefix="fndsa-controlled-asm-") as folder:
        temp = Path(folder)
        for name in ["codec_cm4", "mq_cm4", "sha3_cm4", "sign_fpr_cm4", "sign_sampler_cm4"]:
            blobs = []
            for board in ["m4", "m55"]:
                obj = temp / (board + ".o"); binary = temp / (board + ".bin")
                source = ROOT.parent / ("fn-dsa_" + board) / "ref" / (name + ".s")
                subprocess.run([str(compiler), *flags[board], "-c", str(source), "-o", str(obj)], check=True)
                subprocess.run([str(compiler.with_name("arm-none-eabi-objcopy")), "-O", "binary", "--only-section=.text", str(obj), str(binary)], check=True)
                blobs.append(binary.read_bytes())
            assert blobs[0] == blobs[1], name
            same[name] = dict(bytes=len(blobs[0]), sha256=hashlib.sha256(blobs[0]).hexdigest())
    oracle = json.loads((ROOT / "build/host_oracle.json").read_text())
    assert oracle["warmup_fingerprint"] == [4053617184, 4181047927]
    assert oracle["fingerprint"] == [3060065408, 1579935960]
    evidence.update(compiler_version=version, compiler_sha256=sha(compiler),
        identical_assembly_text=same, host_oracle=oracle, passed=True)
    controller.save(ROOT / "preflight_audit.json", evidence)
    print(json.dumps(evidence, indent=2))

def compare():
    results, sessions, audits = {}, {}, {}
    for board in ["m4", "m55"]:
        results[board], sessions[board], audits[board] = validate_one(board)
    for key in ["core_clock_hz", "hclk_hz", "pclk1_hz", "pclk2_hz", "gcc_version", "runs", "mve_compiled", "assembly", "primask"]:
        assert results["m4"]["header"][key] == results["m55"]["header"][key]
    for key in sessions["m4"]["source_hashes"]:
        if key != "inner.h": assert sessions["m4"]["source_hashes"][key] == sessions["m55"]["source_hashes"][key]
    rows = []
    for d in range(2):
        for op in ["keygen", "sign", "verify"]:
            a = results["m4"]["measurements"][d]["operations"][op]
            b = results["m55"]["measurements"][d]["operations"][op]
            rows.append(dict(degree=512 << d, operation=op, m4_mean_cycles=a["mean"],
                m55_mean_cycles=b["mean"], m4_mean_ms=a["mean"]/24000, m55_mean_ms=b["mean"]/24000,
                m55_over_m4_cycle_ratio=b["mean"]/a["mean"],
                paired_ratio_median=statistics.median([y/x for x,y in zip(a["cycles"],b["cycles"])])))
    comparison = dict(recorded_utc=controller.utc(), rows=rows,
        interpretation="Same implementation under common nominal CPU/bus clock, SRAM and cache-off settings; not pure-core or native-FP64 optimization speedup.")
    controller.save(ROOT / "comparison.json", comparison)
    controller.save(ROOT / "audit.json", audits)
    lines = ["# FN-DSA M4 → M55: SRAM·캐시 OFF·24 MHz 비교", "",
        "상태: **두 보드 각 100회 측정 및 산출물 검증 완료**.", "",
        "같은 소스 커밋·M4 어셈블리·입력·GCC 13.2.1·-O3, CPU/HCLK/PCLK1/PCLK2 24 MHz, 내부 SRAM 실행·캐시 OFF 조건이다. native double과 MVE는 사용하지 않았다.", "",
        "## 결과", "",
        "| 크기 | 연산 | M4 평균 cycles | M55 평균 cycles | M4 평균 ms | M55 평균 ms | M55/M4 cycles |",
        "|---|---|---:|---:|---:|---:|---:|"]
    for r in rows:
        lines.append(f"| {r['degree']} | {r['operation']} | {r['m4_mean_cycles']:,.2f} | {r['m55_mean_cycles']:,.2f} | {r['m4_mean_ms']:,.3f} | {r['m55_mean_ms']:,.3f} | {r['m55_over_m4_cycle_ratio']:.4f} |")
    lines += ["", "비율 > 1은 해당 공통 설정에서 M55가 더 많은 사이클을 사용했다는 뜻이다. 같은 명목 CPU 클럭이므로 명목 실행 시간 비율도 같다. 사이클/시간은 별도의 전력 효율 지표가 아니다.", "",
        "## 해석 한계", "",
        "- M4는 SRAM1 alias의 ICode/DCode, M55는 AXI SRAM2 경로다. SRAM·인터커넥트 지연·코어 파이프라인·메모리 속성 및 CPU 대상별 C 코드 생성 차이는 남는다.",
        "- 따라서 순수 Cortex-M4와 Cortex-M55 코어의 우열이나 M55의 최대 실사용 성능으로 일반화하지 않는다. 캐시 OFF는 특히 캐시를 전제로 설계된 실행 경로에 불리할 수 있다.",
        "- 기존 Flash/24 MHz M4 및 SRAM/cache ON/600 MHz M55 결과는 다른 실험으로 보존했다. 이번 수치와 혼합하여 개선율을 계산하지 않는다.",
        "- 최신 소스를 사용한 대체 M4 보드 실험이다. 논문 당시 F407/-O2/15000회 수치의 완전 재현은 아니다.",
        "- ③ native double은 아직 구현/측정하지 않았다. 이 ② M55 조건을 고정하면 후속 ②→③ 구현 변경 효과를 비교할 수 있다.", "",
        "## 정확성·계측 검증", "",
        "- 모든 정상 서명 검증 성공, 워밍업 변조 서명 거부. 두 보드 및 호스트의 누적 출력 SHAKE256 digest 일치.",
        "- 1200개의 64-bit cycle 표본과 보조 TIM2 시간을 raw mailbox에서 재파싱하고 평균·중앙값·표준편차·최소·최대 재계산.",
        "- DWT의 회전 횟수는 인터럽트 없는 1 MHz TIM2로 복원. 매 API의 DWT/TIM2 경계 오차 제한 확인.",
        "- 원본 소스·이식 패치 범위·실행 ELF·측정 코드 SHA-256 및 공통 클럭/옵션 검증. 전체 upstream KAT 재실행이나 부채널 안전성 감사와는 별개.",
        "- Flash 기록/삭제 없이 SRAM에만 로드. M4 Flash 측정 전후 일치 확인. 측정 종료 후 두 MCU는 halt, 소유 OpenOCD는 종료.", "",
        "## 상세 자료", "",
        "- [M4 전체 통계·원시 표·로그](../fn-dsa_m4/measurement_controlled/result.md).",
        "- [M55 전체 통계·원시 표·로그](../fn-dsa_m55/measurement_controlled/result.md).",
        "- [설정·재현 방법](README.md), [비교 JSON](comparison.json), [검증 JSON](audit.json), [사전 ASM 대조](preflight_audit.json).", ""]
    (ROOT / "result.md").write_text("\n".join(lines))
    print(json.dumps(comparison, indent=2))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(); parser.add_argument("--preflight", action="store_true")
    args = parser.parse_args()
    if args.preflight: preflight()
    else: compare()
