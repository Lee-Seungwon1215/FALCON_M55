#ifndef FNDSA_KGEN_DS_H
#define FNDSA_KGEN_DS_H
/* B-only persistent workspace: one real value is hi+lo binary32.
 * Maximum logn is 10. Workspaces are caller-owned, reentrant, aligned 16.
 * Public degree selection keeps logn < 4 on original fixed-point code. */
typedef struct {
    float re[2][512], im[2][512];
} fndsa_ds_workspace;
void fndsa_ds_import(unsigned, fndsa_ds_workspace *, const fxr *);
/* Return 0 on nonfinite/out-of-range output after scanning every lane. */
int fndsa_ds_export(unsigned, fxr *, const fndsa_ds_workspace *);
void fndsa_ds_forward(unsigned, fndsa_ds_workspace *);
void fndsa_ds_inverse(unsigned, fndsa_ds_workspace *);
int fndsa_ds_reciprocal(unsigned, fndsa_ds_workspace *, unsigned);
void fndsa_ds_mul(unsigned, fndsa_ds_workspace *, const fndsa_ds_workspace *);
int fndsa_ds_div_selfadj(unsigned, fndsa_ds_workspace *, const fndsa_ds_workspace *);
void fndsa_vect_FFT_mve_q32(unsigned, fxr *);
void fndsa_vect_iFFT_mve_q32(unsigned, fxr *);
void fndsa_vect_invnorm_fp64_q32(unsigned, fxr *, const fxr *, const fxr *);
#endif
