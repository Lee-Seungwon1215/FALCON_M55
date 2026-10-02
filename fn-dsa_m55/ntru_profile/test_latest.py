#!/usr/bin/env python3
"""Parser tests; synthetic fixtures are never saved as measurement results."""
import json
from pathlib import Path
import re
import sys
import unittest

sys.dont_write_bytecode = True
import run

ROOT = Path(__file__).resolve().parent


def fixture():
    record = json.loads((ROOT / "results/detailed/validated.json").read_text())
    old = json.loads((Path(record["run_directory"]) / "run.json").read_text())
    raw = (Path(record["run_directory"]) / "raw.log").read_text()
    raw = re.sub(r"Info : [^\n]*\n", "", raw)
    raw = raw.replace("candidate=detailed", "candidate=ntt_opt_fft")
    measured = {"fft", "ifft", "fxp_spectral", "fixed_convert"}
    # The 2026-09-14 fixture predates the later logn output extension.
    raw = re.sub(r"^NTRU_NTT_LOGN .*\n", "", raw, flags=re.M)
    for degree in (512, 1024):
        total = old["totals"][str(degree)]["total"]
        residual = total - sum(old["kernels"][f"{degree}_{k}"]["cycles"] for k in measured)
        for name in run.PHASES:
            value = total if name == "orchestration" else 0
            raw = re.sub(rf"^NTRU_PHASE degree={degree} phase={name} .*?$",
                         f"NTRU_PHASE degree={degree} phase={name} cycles={value} entries=0",
                         raw, flags=re.M)
        for name in set(run.KERNELS) - measured:
            value = residual if name == "other" else 0
            raw = re.sub(rf"^NTRU_KERNEL degree={degree} kernel={name} .*?$",
                         f"NTRU_KERNEL degree={degree} kernel={name} cycles={value} entries=0",
                         raw, flags=re.M)
        for direction in ("forward", "inverse"):
            for logn in range(11):
                raw += (f"\nNTRU_NTT_LOGN degree={degree} direction={direction} "
                        f"logn={logn} cycles=0 entries=0\n")
    return raw


class LatestProfileTests(unittest.TestCase):
    def setUp(self):
        self.raw = fixture()

    def test_valid_focused_fixture(self):
        self.assertEqual(run.validate(self.raw, "ntt_opt_fft")[-1], [])

    def test_wrong_clock_rejected(self):
        self.assertTrue(run.validate(self.raw.replace("cpu=800000000", "cpu=600000000"),
                                     "ntt_opt_fft")[-1])

    def test_missing_fft_rejected(self):
        bad = re.sub(r"^NTRU_KERNEL degree=512 kernel=fft .*\n", "", self.raw, flags=re.M)
        self.assertTrue(run.validate(bad, "ntt_opt_fft")[-1])

    def test_wrong_total_rejected(self):
        bad = re.sub(r"(NTRU_TOTAL degree=512 calls=\d+ total=)\d+", r"\g<1>1", self.raw)
        self.assertTrue(run.validate(bad, "ntt_opt_fft")[-1])

    def test_control_cannot_pass_as_focused(self):
        self.assertTrue(run.validate(self.raw, "ntt_opt_control")[-1])

    def test_current_logn_parser_regression(self):
        record = json.loads((ROOT / "results/logn/validated.json").read_text())
        raw = re.sub(r"Info : [^\n]*\n", "", (Path(record["run_directory"]) / "raw.log").read_text())
        self.assertEqual(run.validate(raw, "logn")[-1], [])


if __name__ == "__main__":
    unittest.main()
