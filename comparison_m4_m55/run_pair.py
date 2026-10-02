#!/usr/bin/env python3
"""Durable supervisor: monitor both controllers and generate final comparison.

Only launch this for a user-authorized, idle pair of the explicit ST-LINKs.
No scheduling service or network access is needed after launch.
"""
import argparse
import fcntl
import json
import os
from pathlib import Path
import subprocess
import sys
import time
import controller

ROOT = Path(__file__).resolve().parent
def run():
    status_path = ROOT / "supervisor.json"
    for b in controller.TARGETS:
        assert not (ROOT.parent / ("fn-dsa_"+b) / "measurement_controlled/session.json").exists()
    subprocess.run([sys.executable, str(ROOT / "verify_results.py"), "--preflight"], check=True)
    children, logs = {}, {}
    state = dict(started_utc=controller.utc(), pid=os.getpid(), phase="starting", children={})
    try:
        for b in controller.TARGETS:
            logs[b] = (ROOT.parent / ("fn-dsa_"+b) / "measurement_controlled/background.log").open("a")
            children[b] = subprocess.Popen([sys.executable, "-B", str(ROOT / "controller.py"), b],
                cwd=ROOT.parent, stdout=logs[b], stderr=subprocess.STDOUT)
            state["children"][b] = dict(pid=children[b].pid)
        while any(p.poll() is None for p in children.values()):
            state["phase"] = "running"; state["updated_utc"] = controller.utc()
            for b, p in children.items(): state["children"][b]["exit_code"] = p.poll()
            controller.save(status_path, state)
            time.sleep(30)
        for b, p in children.items(): state["children"][b]["exit_code"] = p.returncode
        if all(p.returncode == 0 for p in children.values()):
            subprocess.run([sys.executable, "-B", str(ROOT / "verify_results.py")], check=True)
            state["phase"] = "complete"
        else: state["phase"] = "failed_inspect_board_logs"
        state["finished_utc"] = controller.utc(); controller.save(status_path, state)
    except BaseException as exc:
        state["phase"] = "supervisor_error"; state["error"] = repr(exc)
        controller.save(status_path, state)
        raise
    finally:
        for f in logs.values(): f.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(); parser.add_argument("--detach", action="store_true")
    args = parser.parse_args()
    if args.detach:
        assert not (ROOT / "supervisor.json").exists(), "Preserve the previous supervisor record first"
        with (ROOT / "supervisor.log").open("a") as out:
            p = subprocess.Popen(["/usr/bin/caffeinate", "-is", sys.executable, "-B", str(Path(__file__).resolve())],
                cwd=ROOT, stdout=out, stderr=subprocess.STDOUT, start_new_session=True, stdin=subprocess.DEVNULL)
        controller.save(ROOT / "launch.json", dict(launched_utc=controller.utc(), pid=p.pid))
        print("Background supervisor PID:", p.pid)
    else:
        with (ROOT / ".supervisor.lock").open("w") as lock:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            run()
