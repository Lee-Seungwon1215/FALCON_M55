#!/usr/bin/env python3
"""Own only the Stage A probe/server; build, back up, measure, restore."""
import argparse
import datetime
import json
import os
from pathlib import Path
import socket
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parent
LOGS = ROOT / "logs"
OPENOCD = "/Users/seungwon/test/.tools/xpack-openocd-0.12.0-7/bin/openocd"
SERIAL = "066DFF363355473043205442"

def stamp(phase, **extra):
    data = {"phase": phase, "updated_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
            "pid": os.getpid(), **extra}
    path = ROOT / "supervisor.json"
    tmp = path.with_suffix(".tmp")
    tmp.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")
    tmp.replace(path)
    print(json.dumps(data, ensure_ascii=False), flush=True)

def run():
    assert not (ROOT / "session.json").exists(), "Do not overwrite an existing Stage A session"
    usb = subprocess.check_output(["ioreg", "-p", "IOUSB", "-l", "-w", "0"], text=True)
    assert SERIAL in usb, "The exact selected M4 ST-LINK is not connected"
    procs = subprocess.check_output(["ps", "-axo", "pid,command"], text=True)
    # A different active debugger could own this probe even on another port.
    for line in procs.splitlines():
        if any(name in line for name in ["/bin/openocd", "st-util", "ST-LINK_gdbserver"]):
            raise RuntimeError("An existing debug server must be resolved first: " + line)
    with socket.socket() as check:
        check.bind(("127.0.0.1", 6674))
    LOGS.mkdir(exist_ok=True)
    stamp("빌드·호스트 출력 대조 준비")
    with (LOGS / "build.log").open("x") as build_log:
        subprocess.run(["make", "all", "host"], cwd=ROOT, stdout=build_log,
                       stderr=subprocess.STDOUT, check=True)
    stamp("정확한 M4 프로브 연결·새 Flash 백업 준비")
    server = None
    try:
        with (LOGS / "openocd.log").open("x") as server_log:
            server = subprocess.Popen([OPENOCD, "-f", "openocd.cfg", "-c", "init"],
                                      cwd=ROOT, stdin=subprocess.DEVNULL,
                                      stdout=server_log, stderr=subprocess.STDOUT)
            for _ in range(100):
                if server.poll() is not None:
                    raise RuntimeError("Selected M4 OpenOCD exited; inspect its log")
                try:
                    with socket.create_connection(("127.0.0.1", 6674), timeout=0.1):
                        break
                except OSError:
                    time.sleep(0.1)
            else:
                raise RuntimeError("M4 OpenOCD did not open the dedicated TCL port")
            stamp("새 Flash 전체 백업·읽기 검증", openocd_pid=server.pid)
            subprocess.run([sys.executable, "controller.py", "prepare"], cwd=ROOT, check=True)
            stamp("M4 워밍업·100회 본 측정", openocd_pid=server.pid)
            subprocess.run([sys.executable, "controller.py", "run"], cwd=ROOT, check=True)
            stamp("측정·정확성·Flash 복원 검증 완료", openocd_pid=server.pid)
    except Exception as exc:
        stamp("실패 — 로그·복원 상태 확인 필요", error=repr(exc))
        raise
    finally:
        # Only terminate the server we own, never unrelated debuggers or boards.
        if server is not None and server.poll() is None:
            server.terminate()
            try:
                server.wait(timeout=10)
            except subprocess.TimeoutExpired:
                stamp("OpenOCD 종료 확인 필요", openocd_pid=server.pid)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--detach", action="store_true")
    args = parser.parse_args()
    if args.detach:
        assert not (ROOT / "supervisor.json").exists(), "Existing supervisor record must not be overwritten"
        LOGS.mkdir(exist_ok=True)
        with (LOGS / "supervisor.log").open("x") as output:
            child = subprocess.Popen(["/usr/bin/caffeinate", "-i", sys.executable, str(__file__)],
                                     cwd=ROOT, stdin=subprocess.DEVNULL, stdout=output,
                                     stderr=subprocess.STDOUT, start_new_session=True)
        print("Stage A background supervisor PID", child.pid)
    else:
        run()
