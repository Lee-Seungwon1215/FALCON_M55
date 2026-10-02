#!/usr/bin/env python3
"""Read-only regression checks for the new stage-profile comparison tools."""
import copy
import json
from pathlib import Path
import re
import sys
import unittest

sys.dont_write_bytecode = True
import compare_preslothy as compare
import provenance
import report
import run as runner

ROOT = Path(__file__).resolve().parent


class ProfileComparisonTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.bv, _, cls.before_dir = report.load("before")
        cls.av, _, cls.after_dir = report.load("preslothy")
        cls.before = compare.checked_run(cls.before_dir, "before")
        cls.after = compare.checked_run(cls.after_dir, "preslothy")
        cls.raw = re.sub(r"Info : [^\n]*\n", "", (cls.after_dir / "raw.log").read_text())

    def test_validated_raw_and_paths_match(self):
        compare.compatible(self.before, self.after)
        self.assertEqual(self.after["build_provenance"]["inputs"]["baseline"], self.bv)

    def test_sums_are_exclusive_and_complete(self):
        for data in (self.before, self.after):
            for key, total in data["totals"].items():
                cycle_sum = sum(data["categories"][key + "_" + c]["cycles"] for c in report.CATEGORIES)
                self.assertEqual(cycle_sum, total["total"])

    def test_incorrect_totals_are_rejected(self):
        bad = re.sub(r"(PROFILE_TOTAL degree=512 operation=keygen calls=10 total=)\d+",
                     r"\g<1>1", self.raw, count=1)
        self.assertTrue(runner.validate(bad, "preslothy")[3])

    def test_wrong_hardware_is_rejected(self):
        bad = self.raw.replace("PROFILE_HW cpu=800000000", "PROFILE_HW cpu=600000000")
        self.assertTrue(runner.validate(bad, "preslothy")[3])

    def test_wrong_candidate_is_rejected(self):
        self.assertTrue(runner.validate(self.raw, "after")[3])

    def test_missing_phase_is_rejected(self):
        bad = re.sub(r"^PROFILE_CATEGORY degree=512 operation=sign category=sg_fft_basis .+\n",
                     "", self.raw, count=1, flags=re.M)
        self.assertTrue(runner.validate(bad, "preslothy")[3])

    def test_different_output_is_rejected(self):
        bad = copy.deepcopy(self.after)
        bad["fingerprints"]["512"] = "00000000"
        with self.assertRaises(RuntimeError):
            compare.compatible(self.before, bad)

    def test_different_phase_path_is_rejected(self):
        bad = copy.deepcopy(self.after)
        bad["categories"]["512_keygen_kg_ntru"]["entries"] += 1
        with self.assertRaises(RuntimeError):
            compare.compatible(self.before, bad)

    def test_build_provenance_still_matches(self):
        self.assertEqual(provenance.check(), self.after["build_provenance"])

    def test_comparison_json_matches_raw(self):
        data = json.loads((ROOT / "results/preslothy/comparison.json").read_text())
        for key, value in data["totals"].items():
            before, after = self.before["totals"][key], self.after["totals"][key]
            self.assertEqual(value, compare.metrics(before["total"], after["total"], before["calls"]))
        for degree in report.DEGREES:
            for operation in report.OPERATIONS:
                key = f"{degree}_{operation}"
                for name, _ in report.PHASES[operation]:
                    row = data["phases"][key + "_" + name]
                    for side, run in (("before", self.before), ("after", self.after)):
                        cycles = report.category(run, degree, operation, name)["cycles"]
                        self.assertEqual(row[side + "_share_pct"],
                                         report.share(cycles, run["totals"][key]["total"]))


if __name__ == "__main__":
    unittest.main()
