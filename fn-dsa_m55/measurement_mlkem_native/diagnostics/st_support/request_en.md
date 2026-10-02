# NUCLEO-N657X0-Q: reproducible cross-window Flex-ITCM ECC faults depend on ITCMWSDISABLE

Hello ST Technical Support,

Please help determine whether this is a known silicon/integration limitation,
a missing configuration step, or another issue, and advise a supported workaround.
We have reproduced the following on a NUCLEO-N657X0-Q reference board using small
RAM-only assembly kernels, without running an RTOS or cryptographic code.

## Environment

- STM32N657, NUCLEO-N657X0-Q; Cortex-M55 r1p1.
- ITCM and DTCM expanded to 256 KiB each; `ITCMCR=DTCMCR=0x49`.
- Boot HSI configuration, nominal CPU 64 MHz (register-derived, not externally
  measured): `RCC_CFGR1=0x0`, `RCC_CFGR2=0x00100000`, `RCC_HSICFGR=0x8c800000`.
- I/D caches disabled: `CCR=0x201`. ECC checking enabled: `MSCR=0x1300a`.
- Baseline `SYSCFG_CM55TCMCR=0x00000099`; `CM55RSTCR=0` at diagnostic entry.
- `RAMCFG_FLEXRAMCR=0` read back with its peripheral clock enabled. We have not
  assumed this value proves either valid or invalid configuration; please advise.
- OpenOCD commit `4e9b167e1ae5ccb437eb0538440988b3f0ec53cb`, ST-LINK V3J15M6,
  SWD 8 MHz. Arm GNU Toolchain 15.2.Rel1 (15.2.1 20251203).
- FLEXMEM setup/debug-server sequencing follows the Nucleo host helpers in
  mlkem-native commit `637d076aa113d8faaec2277ed4a46b657acaf35f`.
- Physical package/revision markings are not yet collected. Please specify the
  identification information you need; we do not infer a silicon revision from
  the Cortex-M55 core revision.

## Minimal failing placement and controls

The diagnostic controller, vectors and stack run from AXISRAM. With interrupts
masked, the CPU initializes the entire configured ITCM/DTCM using aligned STRD
writes, then writes the test kernel and deterministic input itself. Before each
call, the dumped code and all 128 input bytes are verified, and both TEBR VALID
flags are clear. Each case uses a fresh reset/debugger session.

Five kernels are tested: LDM/STM copy, LDM sum, scalar LDR sum, LDRD sum, and scalar
LDR sum with DSB/ISB after each load. The copy destination is AXISRAM. The scalar
LDR sum has no stack or output-memory access within the kernel.

| Kernel location | Input location | Result, one call per kernel |
|---|---|---|
| AXISRAM `0x34081000` | ITCM `0x10024000` | 5/5 pass |
| Base ITCM `0x10001000` | ITCM `0x10024000` | 5/5 pass |
| Flex-ITCM `0x1001302c` | Different 64 KiB window, `0x10024000` | 5/5 ECC fault |
| Flex-ITCM `0x1002302c` | Same 64 KiB window, `0x10024000` | 5/5 pass |
| Flex-ITCM `0x1001302c` | DTCM `0x30008000` | 5/5 pass |

“Pass” requires correct copy/sum, normal completion and zero CFSR/HFSR/AFSR,
not merely reaching a breakpoint. These are specific tested placements, not a
claim that every possible cross-window access fails.

## Wait-state controls

Keeping the failing code/input placement and bytes unchanged:

| CM55TCMCR | Control | Results across the five kernels |
|---|---|---|
| `0x00000099` | Default wait-state settings | 5/5 fail |
| `0x00800099` | Set ITCMWSDISABLE only | 5/5 pass |
| `0x01000099` | Set DTCMWSDISABLE only | 5/5 fail |
| `0x01800099` | Set both | 5/5 pass |

To separate write/initialization effects from read effects, we then changed the
ITCM wait-state bit independently before initialization/writes and immediately
before the call. No TCM content is rewritten between preparation and the call;
DSB/ISB precedes the call. We tested LDM copy and scalar LDR sum, three fresh-reset
repetitions each, for every combination:

| ITCM wait state during writes | ITCM wait state during reads | Result |
|---|---|---|
| Default | Default | 6/6 fail |
| Default | Disabled | 6/6 pass |
| Disabled | Default | 6/6 fail |
| Disabled | Disabled | 6/6 pass |

Typical failure status in this last series:

```text
LDM copy: CFSR=0x8200 HFSR=0x40000000 AFSR=0x20000 BFAR=0x1002400c
LDR sum:  CFSR=0x8200 HFSR=0x40000000 AFSR=0x20000 BFAR=0x10024000
```

The active TEBR entries identify ITCM. In the earlier five-kernel series, the
LDM sum instead reports FECC (`AFSR=0x10000000`, `CFSR=0x100`); the remaining
kernels report PECC. Full register dumps and stacked fault PCs are attached.

ECC checking remained enabled. Changed wait-state settings were restored to
`0x00000099` before reset. These controls were performed only at the nominal
64 MHz boot configuration; we are **not** asserting that Flex-TCM 0WS is supported
at 800 MHz or proposing it as a validated high-frequency workaround.

## Questions for ST

1. Is this cross-window, wait-state-dependent Flex-ITCM behavior a known issue?
   If so, which silicon revisions are affected, and is there an erratum/reference?
2. Are any additional SYSCFG, RAMCFG, reset, ECC initialization, or other settings
   required beyond the attached sequence for reliable 256/256 KiB operation?
   In particular, is the observed `RAMCFG_FLEXRAMCR=0` consistent with the
   configuration, or does it reveal a missing step?
3. What supported explanation could account for the read-phase dependency while
   write-phase settings do not change the outcome? Could the extension's wait
   response/bank selection/data-ECC delivery be involved, and what additional
   registers or traces would distinguish these possibilities?
4. What are the documented frequency/VOS constraints for ITCMWSDISABLE and
   DTCMWSDISABLE? Please point to the applicable RM0486 section/table. DS14791
   Rev 10 Table 24 states Base-TCM 0WS / Flex-TCM 1WS conditions; our low-frequency
   diagnostic does not establish an allowable 0WS operating range.
5. Is keeping code in ITCM while placing global constants and initialized data
   in DTCM a supported workaround? Are there residual restrictions for literal
   pools or other data reads from extended ITCM?

We found a potentially related community report, but do not assume it is the
same underlying cause or an ST-confirmed defect:
[STM32N657I0 cross-window TCM ECC report](https://community.st.com/stm32-mcus-products-25/reproducible-ecc-error-in-tcm-memory-following-a-certain-access-pattern-with-stm32n657i0-158561).
Its public ST response asks whether it reproduces on a Nucleo/Discovery board;
the attached observations are from NUCLEO-N657X0-Q.

The attachment contains the three completed series (25 + 20 + 24 cases), exact
diagnostic ELF/kernel bytes, source, sanitized logs, reproduction scripts and
file hashes. Local account paths and probe serial are removed, but addresses,
register values, code/data bytes and results are preserved. We can provide
further captures as directed.

Thank you.
