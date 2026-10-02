#!/usr/bin/env python3
"""Read-only regression tests for instrumentation boundaries and log validation."""
import json
from pathlib import Path
import re
import unittest
import instrument
import provenance
import run

def fixture(mode):
    lines = [f"PROFILE_BEGIN candidate={mode} keygen_runs=10 sign_runs=100 verify_runs=100",
             "PROFILE_HW cpu=800000000 ccr=00000611 itcmcr=00000049 dtcmcr=00000049 control=00000099",
             "TCM_CONTROL_START=0x99", "TCM_CONTROL_END=0x99",
             "TCM_MSCR_START=0x1300a", "TCM_MSCR_END=0x1300a",
             "CFSR=0x0", "HFSR=0x0", "AFSR=0x0"]
    for d in (512, 1024):
        for op, calls in run.EXPECTED_CALLS.items():
            total = calls * 100000
            lines.append(f"PROFILE_TOTAL degree={d} operation={op} calls={calls} total={total} min=100000 max=100000")
            active = run.EXPECTED_ACTIVE[op] if mode == "detailed" else ({"ntru_rest"} if op == "keygen" else set())
            for cat in run.CATEGORIES:
                entries = int(cat in active)
                if cat == "ntru_rest" and op == "keygen":
                    entries = 11 if d == 512 else 17
                if mode == "detailed":
                    entries = {("keygen", "mq_div"): 10, ("sign", "mq_div"): 100,
                               ("sign", "mq_mul"): 500, ("verify", "mq_mul"): 100}.get((op, cat), entries)
                cycles = 100 if cat in active else 0
                if cat == "other":
                    cycles = total - 100 * len(active)
                lines.append(f"PROFILE_CATEGORY degree={d} operation={op} category={cat} cycles={cycles} entries={entries}")
        fp = "9895079d" if d == 512 else "a020dd02"
        lines.append(f"PROFILE_FINGERPRINT degree={d} fnv1a={fp}")
    lines += ["PROFILE_STATUS error=0 result=0", "PROFILE_DONE correctness=PASS tamper_rejection=PASS"]
    return "\n".join(lines) + "\n"

class ProfileTests(unittest.TestCase):
    def test_valid_logs(self):
        for mode in ("control", "detailed"):
            self.assertEqual(run.validate(fixture(mode), mode)[3], [])

    def test_invalid_logs(self):
        raw = fixture("detailed")
        for old, new in (("cpu=800000000", "cpu=400000000"),
                         ("ccr=00000611", "ccr=00030611"),
                         ("TCM_MSCR_END=0x1300a", "TCM_MSCR_END=0x13018"),
                         ("HFSR=0x0", "HFSR=0x1"),
                         ("fnv1a=9895079d", "fnv1a=9895079e"),
                         ("category=table_gm cycles=100 entries=1", "category=table_gm cycles=101 entries=1"),
                         ("category=mq_div cycles=100 entries=10", "category=mq_div cycles=100 entries=9"),
                         ("degree=512 operation=keygen calls=10", "degree=511 operation=keygen calls=10"),
                         ("category=table_gm", "category=unknown"),
                         ("PROFILE_DONE correctness=PASS", "PROFILE_DONE correctness=FAIL")):
            with self.subTest(old=old):
                self.assertTrue(run.validate(raw.replace(old, new, 1), "detailed")[3])

    def test_missing_duplicate_rows(self):
        raw = fixture("detailed")
        line = next(s for s in raw.splitlines(True) if s.startswith("PROFILE_CATEGORY"))
        self.assertTrue(run.validate(raw.replace(line, "", 1), "detailed")[3])
        self.assertTrue(run.validate(raw + line, "detailed")[3])

    def test_nine_loops_and_functions(self):
        sites = []
        for name in instrument.SOURCES:
            _, metadata = instrument.expected(provenance.SOURCE, name, "detailed")
            sites.extend(metadata["sites"])
        self.assertEqual(sum(s["kind"] == "loop" for s in sites), 9)
        self.assertEqual(sum(s["kind"] == "function" for s in sites), 5)
        self.assertEqual({s["category"] for s in sites},
                         {"CAT_" + c.upper() for c in run.CATEGORIES} - {"CAT_OTHER", "CAT_MQ_MUL"})

    def test_ntru_direct_pointwise_coverage(self):
        text = (provenance.SOURCE / "kgen_ntru.c").read_text()
        for function in {item[0] for item in instrument.LOOPS["kgen_ntru"]}:
            start, end = instrument.function_bounds(text, function)
            bounds = [instrument.find_loop(text, f, selector) for f, selector, _
                      in instrument.LOOPS["kgen_ntru"] if f == function]
            for match in re.finditer(r"\bmp_(?:mmul|div)\s*\(", instrument.masked(text)[start:end]):
                self.assertTrue(any(a <= start + match.start() < b for a, b in bounds))

    def test_control_only_ntru(self):
        sites = []
        for name in instrument.SOURCES:
            _, metadata = instrument.expected(provenance.SOURCE, name, "control")
            sites.extend(metadata["sites"])
        self.assertEqual(len(sites), 1)
        self.assertEqual(sites[0]["category"], "CAT_NTRU_REST")

    def test_build_provenance(self):
        for mode in ("control", "detailed"):
            self.assertTrue(provenance.check(mode)["ready"])

    def test_live_logs_if_available(self):
        for mode in ("control", "detailed"):
            path = run.ROOT / "results" / mode / "validated.json"
            if path.exists():
                record = json.loads(path.read_text())
                raw = (Path(record["run_directory"]) / "raw.log").read_text()
                raw = re.sub(r"Info : [^\n]*\n", "", raw)
                self.assertEqual(run.validate(raw, mode)[3], [])

if __name__ == "__main__":
    unittest.main()
