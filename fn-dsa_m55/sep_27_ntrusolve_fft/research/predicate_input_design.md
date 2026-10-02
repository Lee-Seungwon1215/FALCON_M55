# A12 hypothesis: exact vector-predicate input selection

Previous turn classification: progress. A11 was directly implemented, passed
fresh gates and repeated whole measurements; it is archived before this
experiment. The 1.7x whole-keygen objective is unchanged and still unmet.

## Scope and original identity

The candidate is confined to the NTRU FFT input boundary, poly_big_to_fixed.
For each of four coefficient lanes, the original scan selects limb j when
its masked index equals one of t0,t1,t2. Under the documented len<2^24
contract both j and each t are 24-bit unsigned values. Consequently

    -(((j xor t)-1) >> 31)

is all ones exactly for j==t, and zero otherwise. A vector equality predicate
followed by a predicated OR implements the same selection without building
the scalar mask, duplicating it and ANDing the data. No precision or
rounding rule changes. The original sign extension, shifts and final stores
are retained. This is derived from the current code, not attributed as a
verbatim paper algorithm or a formal machine-code proof.

## Access and small-size constraints

The trial helper accepts only n>=4 with n divisible by four and len>0.
It reads every limb of four real coefficients with an UNPREDICATED vector
load. A previous secret equality predicate must never govern the next load.
Addresses, stride and both loops depend only on public n/len. The three
secret-scale comparisons affect arithmetic lane updates only.

The test wrapper delegates n=1/2 to the incumbent and retains len=0 zeroing.
Those delegated cases are boundary coverage, not executions of the new
four-lane scan. If adopted, the production assembly must preserve the
existing single-coefficient load mask and A11 paired-limb path. The valid
DIVREM31 scale domain remains 0..63487. No secret-indexed load or early exit.

## Measurement gates

The test-only predicate_board.c compares original C, incumbent and new
helper on common inputs/ELF. It reuses the 220672-case boundary grid with
three-way output/guard comparisons, and times n=4,len=32 and n=512,len=8
over 32 input/scale classes x20 trials. Twenty-five size/length combinations
also compare wrapper-inclusive time. Different function addresses are not
claimed identical. The current candidates and prior logs are not changed
until the isolated experiment passes. Then all current-source production
gates and whole measurements must be rerun; no historical pass is inherited.

Finite timing, raw comparisons and address review do not prove universal
constant-time, physical leakage security or worst-case stack safety.
The original all-limb scanning policy and NTRU work counts are unchanged.

## Independent B opportunity and subsequent implementation

Reading B14's DSS_SELECT_CORE finds the same scalar mask materialization
inside both fndsa_ds_select4 and fndsa_ds_from_big_span. Its q5 is scratch
during selection and then overwritten for sign extension. Therefore the
same exact predicate identity is a plausible independent B change, while
keeping B's continuous DS storage and encoder unchanged. It needs its own
source snapshot, raw selector/FP32 expansion tests and full gates. A's raw
Q32 tests are not automatically evidence for B's complete encoded outputs.
This was a next hypothesis during the A12 experiment. B15 subsequently
implements it locally in B; its separate evidence is recorded in
../validation/b15_predicate_input_results.md. A12's tests are not inherited.
