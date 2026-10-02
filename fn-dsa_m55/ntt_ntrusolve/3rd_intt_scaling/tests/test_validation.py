"""Host-only regression tests; never starts a loader or changes crypto sources.

Run: python3 -B -m unittest discover -s <stage>/tests -v
"""
import importlib.util
import json
from pathlib import Path
import re
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.dont_write_bytecode = True
STAGE = Path(__file__).resolve().parents[1]


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


audit = load_module("h1_audit_test", STAGE / "H1_final_scaling/profiling/m55.py")
ntru = load_module("ntru_test", STAGE / "experiments/ntru_total/run.py")


def valid_audit():
    rows = [
        "MP31_EXACT primes=308 logn=4..10 transforms=2156 forward_mismatches=0 "
        "inverse_mismatches=0 roundtrip_mismatches=0 max_mod_error=0 "
        "first_prime=4294967295 first_logn=0 first_index=0",
        "MP31_ROUNDING cases=18923520 mismatches=0 range_errors=0 "
        "first_prime=4294967295 first_root=0",
    ]
    rows += [f"MP31_CYCLES logn={logn} direction={direction} batch={batch} "
             "calls=100 total=34382 per_call=343 twiddle_prepare=included"
             for logn in range(4, 11) for direction in ("forward", "inverse")
             for batch in range(10)]
    return "\n".join(rows) + "\n"


class AuditTests(unittest.TestCase):
    def test_valid_contract(self):
        result = audit.parse_audit(valid_audit())
        self.assertEqual(result["exact"]["logn"], "4..10")
        self.assertEqual(len(result["cycle_batches"]), 140)

    def test_saved_h0_h1_audits(self):
        for path in (
            "H1_final_scaling/profiling/results/h1-h1_final_v1-audit/pilot_validated.json",
            "experiments/h0_layout/profiling/results/h0_layout-final_v1-audit/pilot_validated.json",
        ):
            with self.subTest(path=path):
                record = json.loads((STAGE / path).read_text())
                self.assertTrue(record["valid"])
                raw = (Path(record["run_directory"]) / "raw.log").read_text()
                result = audit.parse_audit(raw)
                self.assertEqual(int(result["exact"]["transforms"]), 2156)

    def test_zero_coverage_review_reproducer(self):
        raw = valid_audit().replace("transforms=2156", "transforms=0")
        raw = raw.replace("cases=18923520", "cases=0")
        raw = raw.replace("calls=100 total=34382 per_call=343", "calls=0 total=0 per_call=0")
        with self.assertRaises(RuntimeError):
            audit.parse_audit(raw)

    def test_incomplete_or_wrong_coverage(self):
        mutations = [
            ("primes=308", "primes=307"),
            ("transforms=2156", "transforms=0"),
            ("transforms=2156", "transforms=2155"),
            ("transforms=2156", "transforms=2157"),
            ("logn=4..10", "logn=4..9"),
            ("logn=4..10", "logn=4"),
            ("cases=18923520", "cases=0"),
            ("cases=18923520", "cases=10092544"),  # unsigned-only coverage
            ("cases=18923520", "cases=18923519"),
            ("cases=18923520", "cases=18923521"),
        ]
        for old, new in mutations:
            with self.subTest(new=new), self.assertRaises(RuntimeError):
                audit.parse_audit(valid_audit().replace(old, new))

    def test_nonzero_errors_and_failure_markers(self):
        for old in ("forward_mismatches=0", "inverse_mismatches=0", "roundtrip_mismatches=0",
                    "max_mod_error=0", "mismatches=0", "range_errors=0", "first_root=0",
                    "first_logn=0", "first_index=0"):
            with self.subTest(field=old), self.assertRaises(RuntimeError):
                audit.parse_audit(valid_audit().replace(old, old[:-1] + "1"))
        with self.assertRaises(RuntimeError):
            audit.parse_audit(valid_audit().replace("first_prime=4294967295", "first_prime=0"))

    def test_duplicate_missing_or_malformed_records(self):
        lines = valid_audit().splitlines()
        for index in (0, 1, 2):
            for change in (lines + [lines[index]], lines[:index] + lines[index+1:],
                           lines + [lines[index].split()[0]], lines + [lines[index] + " broken"]):
                with self.subTest(index=index), self.assertRaises(RuntimeError):
                    audit.parse_audit("\n".join(change))

    def test_duplicate_missing_or_bad_fields(self):
        for old, new in (("primes=308", "primes=308 primes=308"),
                         ("cases=18923520", "cases=18923520 cases=0"),
                         ("transforms=2156", ""),
                         ("transforms=2156", "transforms=2..5"),
                         ("cases=18923520", "cases=-1")):
            with self.subTest(new=new), self.assertRaises(RuntimeError):
                audit.parse_audit(valid_audit().replace(old, new))

    def test_invalid_timing_batches(self):
        for old, new in (("calls=100", "calls=0"), ("calls=100", "calls=99"),
                         ("total=34382", "total=0"), ("per_call=343", "per_call=0"),
                         ("per_call=343", "per_call=344"),
                         ("total=34382", "total=18446744073709551616"),
                         ("twiddle_prepare=included", "twiddle_prepare=excluded"),
                         ("direction=forward", "direction=unknown"),
                         ("batch=0", "batch=10"), ("logn=4 direction", "logn=3 direction")):
            with self.subTest(new=new), self.assertRaises(RuntimeError):
                audit.parse_audit(valid_audit().replace(old, new, 1))


class ProvenanceTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="h1-validation-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name).resolve()
        self.source = self.root / "H1_final_scaling"
        self.task = self.root / "experiments/ntru_total"
        self.build = self.task / "h1/build/control"
        self.source.mkdir()
        (self.build / "generated").mkdir(parents=True)
        for name in [n+".c" for n in ntru.C_NAMES] + [n+".s" for n in ntru.S_NAMES] + ["inner.h"]:
            (self.source / name).write_text("fixture " + name + "\n")
        self.support = self.root / "harness.c"
        self.support.write_text("test harness\n")
        mock = patch.object(ntru, "support_hashes", lambda: {str(self.support): ntru.sha(self.support)})
        mock.start()
        self.addCleanup(mock.stop)
        generated = {"source": str(self.source), "mode": "control", "files": {}}
        commands = []
        for name in ntru.C_NAMES:
            filename = name + ".c"
            (self.build / "generated" / filename).write_text("instrumented " + filename)
            generated["files"][filename] = {
                "sha256": ntru.sha(self.source / filename),
                "hooks": {"solve_NTRU": "total"} if name == "kgen_ntru" else {},
            }
            commands.append(self.command(self.build / "generated" / filename))
        commands += [self.command(self.source / (n + ".s")) for n in ntru.S_NAMES]
        for name in ntru.BUILD_ARTIFACTS:
            path = self.build / name
            path.parent.mkdir(exist_ok=True, parents=True)
            path.write_bytes(("fixture " + name).encode())
        ntru.write_json(self.build / "generated/manifest.json", generated)
        ntru.write_json(self.build / "compile_commands.json", commands)
        self.rebuild_manifest()

    def command(self, path):
        return {"file": str(path), "directory": str(self.build),
                "arguments": ["gcc", "-O2", "-O3", "-DFNDSA_MVE_MP31=1", "-c", str(path)]}

    def rebuild_manifest(self):
        ntru.prepare_build(self.source, self.build)
        self.manifest = ntru.record_build(self.source, self.build)

    def test_valid_build_and_archive(self):
        self.assertEqual(ntru.check_build(self.source, self.build), self.manifest)
        out = self.root / "run"
        out.mkdir()
        ntru.archive_build(self.source, self.build, out, self.manifest)
        self.assertEqual(ntru.source_hashes(out / "source"), self.manifest["sources"])

    def test_all_six_assembly_files_and_headers_are_bound(self):
        for name in [n+".s" for n in ntru.S_NAMES] + ["inner.h", "kgen_mp31.c"]:
            path = self.source / name
            original = path.read_bytes()
            try:
                path.write_bytes(original + b"changed\n")
                with self.subTest(name=name), self.assertRaisesRegex(RuntimeError, "C/H/S"):
                    ntru.check_build(self.source, self.build)
            finally:
                path.write_bytes(original)

    def test_file_addition_removal_and_symlink(self):
        extra = self.source / "new.h"
        extra.write_text("new")
        with self.assertRaises(RuntimeError):
            ntru.check_build(self.source, self.build)
        extra.unlink()
        header = self.source / "inner.h"
        header.unlink()
        with self.assertRaises(RuntimeError):
            ntru.check_build(self.source, self.build)
        header.symlink_to(self.support)
        with self.assertRaises(RuntimeError):
            ntru.check_build(self.source, self.build)

    def test_legacy_incomplete_and_wrong_path_builds_rejected(self):
        path = self.build / ntru.BUILD_MANIFEST
        path.unlink()
        with self.assertRaisesRegex(RuntimeError, "no legacy bypass"):
            ntru.check_build(self.source, self.build)
        ntru.prepare_build(self.source, self.build)
        with self.assertRaisesRegex(RuntimeError, "no completed build"):
            ntru.check_build(self.source, self.build)
        bad = dict(self.manifest, source_dir="/incorrect-source")
        ntru.write_json(path, bad)
        with self.assertRaises(RuntimeError):
            ntru.check_build(self.source, self.build)

    def test_changed_inputs_during_build_are_rejected(self):
        ntru.prepare_build(self.source, self.build)
        (self.source / "inner.h").write_text("changed during build")
        with self.assertRaisesRegex(RuntimeError, "while building"):
            ntru.record_build(self.source, self.build)
        self.assertFalse(json.loads((self.build / ntru.BUILD_MANIFEST).read_text())["ready"])

    def test_changed_harness_is_rejected(self):
        self.support.write_text("changed")
        with self.assertRaisesRegex(RuntimeError, "diagnostic inputs"):
            ntru.check_build(self.source, self.build)

    def test_changed_artifacts_and_generated_c_are_rejected(self):
        for name in ntru.BUILD_ARTIFACTS + ("generated/kgen_ntru.c",):
            path = self.build / name
            original = path.read_bytes()
            try:
                path.write_bytes(original + b"changed")
                with self.subTest(name=name), self.assertRaisesRegex(RuntimeError, "artifacts"):
                    ntru.check_build(self.source, self.build)
            finally:
                path.write_bytes(original)

    def test_rebuild_during_measurement_is_rejected(self):
        before = self.manifest
        (self.source / "inner.h").write_text("new header")
        self.rebuild_manifest()
        with self.assertRaisesRegex(RuntimeError, "during measurement"):
            ntru.check_build(self.source, self.build, before)

    def test_wrong_compile_settings_are_rejected(self):
        path = self.build / "compile_commands.json"
        good = json.loads(path.read_text())
        for args in (["gcc", "-O3"], ["gcc", "-DFNDSA_MVE_MP31=1", "-O3", "-O2"]):
            commands = json.loads(json.dumps(good))
            commands[0]["arguments"] = args
            ntru.write_json(path, commands)
            ntru.prepare_build(self.source, self.build)
            with self.subTest(args=args), self.assertRaises(RuntimeError):
                ntru.record_build(self.source, self.build)

    def test_changed_assembly_is_rejected_before_board_launch(self):
        (self.source / "kgen_mp31_cm55.s").write_text("changed ASM")
        with patch.object(ntru, "TASK", self.task), patch.object(ntru, "STAGE", self.root), \
                patch.object(sys, "argv", ["run.py", "h1"]), patch.object(ntru.subprocess, "Popen") as board:
            with self.assertRaisesRegex(RuntimeError, "C/H/S"):
                ntru.main()
            board.assert_not_called()
        self.assertFalse((self.task / "h1/results").exists())

    def test_changed_assembly_during_run_cannot_validate(self):
        old = json.loads((STAGE / "experiments/ntru_total/h1/results/control/validated.json").read_text())
        raw = (Path(old["run_directory"]) / "raw.log").read_text()
        def launch(*args, **kwargs):
            (self.source / "kgen_mp31_cm55.s").write_text("changed during board run")
            from unittest.mock import Mock
            return Mock(stdout=iter(raw.splitlines(True)), wait=lambda: 0)
        with patch.object(ntru, "TASK", self.task), patch.object(ntru, "STAGE", self.root), \
                patch.object(sys, "argv", ["run.py", "h1"]), patch.object(ntru.subprocess, "Popen", side_effect=launch), \
                patch("builtins.print"):
            self.assertEqual(ntru.main(), 1)
        results = self.task / "h1/results/control"
        self.assertFalse((results / "validated.json").exists())
        metadata = json.loads(next(results.glob("runs/*/run.json")).read_text())
        self.assertFalse(metadata["valid"])
        self.assertTrue(any("provenance" in e for e in metadata["validation_errors"]))

    def test_valid_mocked_run_archives_build_provenance(self):
        old = json.loads((STAGE / "experiments/ntru_total/h1/results/control/validated.json").read_text())
        raw = (Path(old["run_directory"]) / "raw.log").read_text()
        from unittest.mock import Mock
        process = Mock(stdout=iter(raw.splitlines(True)), wait=lambda: 0)
        with patch.object(ntru, "TASK", self.task), patch.object(ntru, "STAGE", self.root), \
                patch.object(sys, "argv", ["run.py", "h1"]), \
                patch.object(ntru.subprocess, "Popen", return_value=process), patch("builtins.print"):
            self.assertEqual(ntru.main(), 0)
        record = json.loads((self.task / "h1/results/control/validated.json").read_text())
        run = Path(record["run_directory"])
        self.assertTrue(record["valid"])
        self.assertEqual(record["build_provenance_sha256"], ntru.sha(run / ntru.BUILD_MANIFEST))
        self.assertEqual(json.loads((run / ntru.BUILD_MANIFEST).read_text()), self.manifest)

    def test_archive_copy_race_is_rejected(self):
        out = self.root / "run"
        out.mkdir()
        real_copy = ntru.shutil.copy2
        def corrupt_copy(src, dst):
            result = real_copy(src, dst)
            if Path(dst).name == "kgen_mp31_cm55.s":
                Path(dst).write_text("corrupted copy")
            return result
        with patch.object(ntru.shutil, "copy2", side_effect=corrupt_copy):
            with self.assertRaisesRegex(RuntimeError, "archived sources"):
                ntru.archive_build(self.source, self.build, out, self.manifest)


if __name__ == "__main__":
    unittest.main()
