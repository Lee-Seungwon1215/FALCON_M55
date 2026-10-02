# Schedule audit trail

`falcon_f3_unscheduled.s` is the extracted compiler reference.
`falcon_f3_scheduled_v2.s` and its JSON are the current audited schedule.
All 32-bit register lanes including ip=r12/fp=r11 and D/S aliases are tracked.

The earlier `falcon_f3_scheduled.s/.json` are SUPERSEDED diagnostic artifacts.
Their adapter did not track the ip/fp aliases and their manifest input lists
were accidentally cleared. The first kernel run at 20260923T002841Z passed
finite tests, but is not accepted as validation of the corrected final source.
Those artifacts are retained for transparency, not selected in any build.
