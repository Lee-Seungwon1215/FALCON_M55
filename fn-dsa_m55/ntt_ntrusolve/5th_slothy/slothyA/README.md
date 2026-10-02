# RNS Slothy A — iteration-local scheduling

Same C/H/S source baseline and q-NTT Slothy A as `../baseline`.
Only this folder's `kgen_mp31_cm55.s` changes RNS execution ordering.
Twelve loop/body regions are scheduled by pinned Slothy with constrained vector
renaming, no spills, atomic VPT/VADDT and VLD4/VST4, and serialized memory events.
The inverse final scaling and logn=4 shared-body entry are preserved.

Firmware needs no Slothy installation and imports no candidate assembly.
Slothy and the conservative adapter are offline generation tools only.

```sh
bash ../measurement/build.sh slothyA audit
python3 ../measurement/run.py slothyA audit pilot --label NEW_LABEL
bash ../measurement/build.sh slothyA perf
python3 ../measurement/run.py slothyA perf pilot --label NEW_LABEL
python3 ../measurement/run.py slothyA perf full --label NEW_LABEL
```

[Results and limitations](../result.md), [generation provenance](../tooling/logs/manifest.json).
