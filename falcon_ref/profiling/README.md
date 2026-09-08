# Falcon-512 exclusive-cycle profiler

This profiler partitions each public Falcon API operation into mutually
exclusive categories.  The reported category shares therefore add up to
exactly 100% (apart from decimal display rounding).  Nested work is charged to
the innermost active category; for example, sampler time is excluded from the
LDL-tree category.

## Host functional check

```sh
make
make run
```

Host output is measured in nanoseconds.  It validates the profiler and gives a
host-specific profile; it must not be used as Cortex-M55 optimization data.

## NUCLEO-N657X0-Q Cortex-M55 target

The ready-to-run SRAM benchmark is in `stm32n657/`.  It uses the official
NUCLEO-N657X0-Q FSBL settings (600 MHz CPU, 400 MHz AXI and 200 MHz HCLK) and
Arm GNU Toolchain flags for Cortex-M55.  It records raw counters in
`falcon_profile_stats` and stops on a breakpoint; no UART or external-flash
write is required.

```sh
cd stm32n657
make
```

The Nucleo board must be in development mode (BOOT1 switch position 2-3;
BOOT0 does not matter).  The
benchmark RNG is deterministic for repeatable profiles and is **not secure**;
it must not be reused in production code.

PQClean's Falcon `clean` implementation represents `fpr` values with
`uint64_t` and implements binary64 arithmetic in software.  Thus its FFT
category is a useful baseline, but merely enabling the M55 FPU does not turn
that code into hardware floating-point instructions.  A native-FPU rewrite
must be measured as a separate optimized variant.

## Generic Cortex-M55 integration

Compile `falcon_profile.c` with `FALCON_PROFILE_CORTEX_M` and include it in the
board application.  The profiler then enables and reads DWT CYCCNT and reports
cycles.  If the platform locks DWT, also define `FALCON_PROFILE_DWT_UNLOCK`.
The board startup, linker script, UART/`printf` retargeting, and production RNG
remain platform responsibilities.

Recommended clean baseline flags include:

```text
-O3 -mcpu=cortex-m55 -mthumb -mfloat-abi=hard -fno-tree-vectorize
```

Measure an auto-vectorized build separately; do not mix it into the clean
baseline.  Ensure the linker provides enough stack: the PQClean API wrapper's
Falcon-512 dynamic-signing temporary buffer alone is 36 KiB.
