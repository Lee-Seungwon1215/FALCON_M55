# RNS Slothy baseline

K4-C RNS NTT/iNTT + already adopted q=12289 Slothy A.
All C/H/S implementations are local regular files, copied from `../../ref_slothy`.

The arithmetic/instruction order of `kgen_mp31_cm55.s` is preserved. Function
sections and a duplicate forward stride literal allow identical benchmark
addresses across candidates. Pristine input is archived at
`../tooling/logs/baseline_original.s` (SHA-256 bad74cbe6f569a948b70f887b47cc0c5fc9f7e6130605df27adb70f3d88ece88).

Build from this folder's sources:

```sh
bash ../measurement/build.sh baseline audit
python3 ../measurement/run.py baseline audit pilot --label NEW_LABEL
bash ../measurement/build.sh baseline perf
python3 ../measurement/run.py baseline perf pilot --label NEW_LABEL
python3 ../measurement/run.py baseline perf full --label NEW_LABEL
```

See [matched results](../result.md). Older results were not copied here.
