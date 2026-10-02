# TWFalcon
This repository contains the code for the paper [TWFalcon: Triple-Word Arithmetic for Falcon; Giving Falcon the Precision to Fly Securely](https://eprint.iacr.org/2025/1991).
In the folder pqm4, the modifications made for this work of the fn-dsa code are located.
It is not the full pqm4 library, but only the modified and added files, in their correct spots.

Then, there is the folder c-fn-dsa-multiple. 
This folder contains a modification from the [c-fn-dsa library](https://github.com/pornin/c-fn-dsa/tree/main), 
from commit hash '96e3b92c4f1bafa23545388a207954fef1a74c90',
that makes it possible to test Falcon with the triple-float arithmetic, print the exponent values of floating-point arithmetic, 
and print the values of mu to see the value range.

Additionally, there is the folder c-fn-dsa-precision-test. 
This folder is also a modification from the c-fn-dsa library, but this time with code to compute the error values that occur in Falcon, for both versions that use the double type, integer emulated double, or triple-float.

Next, the usage of the code in each folder will be explained.

### pqm4
This folder includes a bash script, that can be used to replace and add the correct files from this folder to a version of the 
[pqm4 repository](https://github.com/mupq/pqm4).
This was tested to work with commit hash "a24bb4b662016968c19f5e6a0719c9ad530f0286".
To use this file, first the repository has to be cloned with submodules to your machine. This can be done with the following command:
```bash
git clone --recursive https://github.com/mupq/pqm4.github
```

Then the correct commit has to be checked out.
Then, the bash script can be used with as input the path to the pqm4 library of this repository and the pqm4 library on your machine:
```bash
./apply.sh /path/to/pqm4_of_this_git /path/to/pqm4_your_machine
```
After this command, the files for fndsa are in the pqm4 library, and the library can be used through the usual methods to compile for a machine and run the code.
Note, after these patches the pqm4 library only works for FNDSA, and not any other schemes, therefore the files should be built through make with the argument "IMPLEMENTATION_PATH":
```bash 
make -j4 PLATFORM=your-platform IMPLEMENTATION_PATH=crypto_sign/fndsa_provisional-512/m4f/
```
Where 512 can be changed to 1024 for the other version of FNDSA.

In this code, there are new flags that can be set in the file "/pqm4/crypto_sign/fndsa_provisional-512/mf4/archflags.h"
The archflags are FNDSA_TW and FNDSA_TW_ASM. 
The flag FNDSA_TW enables the triple-float algorithms, which will still use the fma isntruction instead of an emulated emulated 
version of the algorithm.
Then, the FNDSA_TW_ASM enables assembly optimized versions of the triple-float algorithms, but requires FNDSA_TW to be enabled as well.
To use the hardware FMA instruction, the variable FMA_ARMV7 in /pqm4/mupq/crypto_sign/fndsa_provisional-512/ref/triple_float.h should be set.


### c-fn-dsa-multiple
This folder has the code for 3 different executables. 
They can all be build using the make file, but require separate flags to be set to work correctly.
The flags for this library should be set in the file "inner.h".

The first one is test_fndsa, which can be used to test the code in c-fn-dsa. 
This is modified from the original code to also work for the triple-float implementation.
To test the triple-float version, the flag FNDSA_TW has to be enabled. 
If it is disabled, it will test the integer emulated code.

Additionally, print_fpr_exponent compiles runs a multithreaded program that computes how often each the exponent occurs 
in x amount of signature runs separately for every operation. 
The result is saved to a .csv file, which has the columns' operation, exponent, and count.
Multiple things can be configured for this executable in the file "print_fpr_exponents.c".
Firstly, variable LOG can be set to FNDSA_LOGN_1024 or FNDSA_LOGN_512 to run either one of the algorithms.
Then, SIG_RUNS can be set to how many signature runs have to occur to collect enough data.
Additionally, NUM_THREADS can be set to how many threads will be created to execute the program.

The last possible executable is print_mu. This version stores the floating-point values of mu to a .csv file, 
which is used to figure out what the range of mu is. 
For this executable, PRINT_MU has to be enabled.
Additionally, the program can be configured in the file print_mu.c.
The variable SIG_RUNS can be set to how many signature runs should be performed for the collection of mu,
while LOG can be set to either FNDSA_LOGN_1024 or FNDSA_LOGN_512.

All can be build and ran by the command:
```bash
make executable_name && ./executable_name
```
In the next table you can see what the values for each flag have to be for each executable.

|executable | FNDSA_TW | PRINT_EXPONENTS | PRINT_MU|
|:----------|:---------|-----------------|---------|
|test_fndsa | 1 or 0   | 0               | 0       |
|print_fpr_exponents | 0   | 1               | 0       |
|print_mu | 0   | 0               | 1       |

### c-fn-dsa-precision-test
This folder has an implementation of the library c-fn-dsa that computes the relative and absolute error of the inputs to the 
gaussian sampler, to recreate the precision tests from which the results are stated in the Falcon specification.
The `fpr` type was modified to have a struct that holds an integer emulated double value, a real double value, a tw value, 
a 'high' precision mpfr value and a 'low' precision mpfr value.
All fpr operations are modified to perform the computation for each type of value separately.
The [mpfr library](https://www.mpfr.org/) is used and thus has to be installed on your machine to run this executable.
The 'high' precision value is used to emulate an infinite precision value that is seen as the 'real' value, which is then 
used to compute the absolute and relative error from each of the other fpr values.
All constants are recomputed for the 'high' precision and triple float versions.
The code to compute the error and save it, is in sign_sampler.c.
Only the exponent $e$ of the error values are saved, for the form $0.xxx \cdot 2^{-e}$.
The relative error of mu, the absolute error of sigma, and the addition of the two for all fpr value types 
are saved to a csv file.

The mpfr library allocates a lot of memory, and to clean this up manually would mean the full codebase had to be massively modified.
To get around this, the [Boehm–Demers–Weiser garbage collector](https://www.hboehm.info/gc/) is used to automatically clean up the code.
This can be installed on debian/ubuntu using the command `apt install libgc-dev`.
For this code, the variables in inner.h that have to be set are TEST_PRECISION, PRINT_ERRORS, while FNDSA_TW should not be set.
This is already set correctly.
Additionally, the variable SIG_RUNS can be set to how many signature runs should be performed for the collection of error exponents,
while LOG can be set to either FNDSA_LOGN_1024 or FNDSA_LOGN_512.

# License

This project is licensed under the MIT License. You are free to use, modify, and distribute this software in accordance with the terms of the MIT license.

### Third-Party Dependencies

This repository makes use of third-party libraries and code that are licensed under different terms, including Apache-2.0, CC0 and public domain.

Please refer to the individual repositories and their respective LICENSE files for more details. Specifically, all files in the pqm4 folder act as a patch to the repository [pqm4 repository](https://github.com/mupq/pqm4), all licenses of this repository still apply.
