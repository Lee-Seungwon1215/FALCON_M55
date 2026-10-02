# RNS Slothy B — guarded halving pipelines

Starts from A's local schedules, then reschedules the late half of an iteration
with the early half of the next: `a; (b;a)^(N-1); b`.
Public loop guards support N=1 without speculative out-of-bounds reads. Pointer
loops account for whether the first-stream writeback occurs in a or b.
The shared-entry inverse final-two body uses A only.

This is the paper's halving heuristic using Slothy's local solver, not a claim
that native full modulo-scheduling mode was enabled. Memory order is conservative.
All optimized instructions are directly in this folder's standalone `.s` file.

```sh
bash ../measurement/build.sh slothyB audit
python3 ../measurement/run.py slothyB audit pilot --label NEW_LABEL
bash ../measurement/build.sh slothyB perf
python3 ../measurement/run.py slothyB perf pilot --label NEW_LABEL
python3 ../measurement/run.py slothyB perf full --label NEW_LABEL
```

[Results and limitations](../result.md), [generation provenance](../tooling/logs/manifest.json).
