import re
import unittest
from run import validate_measurements


def valid_log(pilot=False):
    n = 1 if pilot else 10
    lines = [f"FNDSA_BEGIN mode={'pilot' if pilot else 'full'} batches={n} warmups={n} iterations={n}"]
    for degree in (512, 1024):
        for op in range(3):
            totals = [10003 + 123 * j + 71 * op + degree for j in range(n)]
            for j, total in enumerate(totals):
                lines.append(f"BATCH degree={degree} batch={j} op={op} total={total} per_call={total//n}")
            line = f"SUMMARY degree={degree} op={op} upper_median={totals[n//2]//n}"
            line += "".join(f" p{p}={totals[n*p//100]//n}"
                            for p in (1, 10, 20, 30, 40, 50, 60, 70, 80, 90, 99))
            lines.append(line)
    return "\n".join(lines)


class Validation(unittest.TestCase):
    def test_full(self):
        samples, errors = validate_measurements(valid_log(), False)
        self.assertEqual(len(samples), 60)
        self.assertEqual(errors, [])

    def test_pilot(self):
        samples, errors = validate_measurements(valid_log(True), True)
        self.assertEqual(len(samples), 6)
        self.assertEqual(errors, [])

    def test_duplicate_zero_wrong_division(self):
        raw = re.sub(r"^BATCH .+$", "BATCH degree=512 batch=0 op=0 total=0 per_call=999",
                     valid_log(), flags=re.M)
        self.assertTrue(validate_measurements(raw, False)[1])

    def test_wrong_summary(self):
        raw = re.sub(r"upper_median=\d+", "upper_median=0", valid_log(), count=1)
        self.assertTrue(validate_measurements(raw, False)[1])

    def test_missing_batch(self):
        raw = re.sub(r"^BATCH .+\n", "", valid_log(), count=1, flags=re.M)
        self.assertTrue(validate_measurements(raw, False)[1])

    def test_wrong_mode(self):
        self.assertTrue(validate_measurements(valid_log(), True)[1])


if __name__ == "__main__":
    unittest.main()
