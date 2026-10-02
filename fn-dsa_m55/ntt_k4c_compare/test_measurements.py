#!/usr/bin/env python3
"""Regression tests for parsing and rejecting damaged measurement records."""
import re
import unittest

from board_runner import validate_measurements


def fixture(pilot):
    batches, calls = (1, 1) if pilot else (10, 10)
    mode = 'pilot' if pilot else 'full'
    lines = [f'FNDSA_BEGIN mode={mode} batches={batches} warmups={calls} iterations={calls}']
    for degree in (512, 1024):
        for op in range(3):
            totals = [degree * 100 + op * 1000 + b * 13 for b in range(batches)]
            lines += [f'BATCH degree={degree} batch={b} op={op} total={t} per_call={t//calls}'
                      for b, t in enumerate(totals)]
            summary = f'SUMMARY degree={degree} op={op} upper_median={totals[batches//2]//calls}'
            for p in (1, 10, 20, 30, 40, 50, 60, 70, 80, 90, 99):
                summary += f' p{p}={totals[batches*p//100]//calls}'
            lines.append(summary)
    return '\n'.join(lines) + '\n'


class MeasurementsTest(unittest.TestCase):
    def test_valid_counts(self):
        for pilot, count in ((True, 6), (False, 60)):
            samples, errors = validate_measurements(fixture(pilot), pilot)
            self.assertEqual(errors, [])
            self.assertEqual(len(samples), count)

    def test_missing_batch(self):
        raw = re.sub(r'^BATCH .+\n', '', fixture(False), count=1, flags=re.M)
        self.assertTrue(validate_measurements(raw, False)[1])

    def test_duplicate_batch(self):
        raw = fixture(False)
        raw += re.search(r'^BATCH .+$', raw, re.M)[0] + '\n'
        self.assertTrue(validate_measurements(raw, False)[1])

    def test_wrong_cycle_division(self):
        raw = fixture(False).replace('total=51200 per_call=5120', 'total=51200 per_call=5121', 1)
        self.assertTrue(validate_measurements(raw, False)[1])

    def test_wrong_summary(self):
        raw = re.sub(r'upper_median=\d+', 'upper_median=0', fixture(False), count=1)
        self.assertTrue(validate_measurements(raw, False)[1])

    def test_pilot_cannot_be_full(self):
        self.assertTrue(validate_measurements(fixture(True), False)[1])

    def test_missing_summary(self):
        raw = re.sub(r'^SUMMARY .+\n', '', fixture(False), count=1, flags=re.M)
        self.assertTrue(validate_measurements(raw, False)[1])


if __name__ == '__main__':
    unittest.main()
