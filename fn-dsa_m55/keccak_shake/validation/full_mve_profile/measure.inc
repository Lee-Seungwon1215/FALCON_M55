/* Measurement-only globals live in DTCM, never in the public SHAKE state. */
volatile uint32_t phase_ticks[128] __attribute__((aligned(32)));
extern void phase_calibrate(void);
static uint32_t phase_samples[100][12];
static void phase_measure(void) {
    for(unsigned s=0;s<105;s++) {
        for(unsigned j=0;j<25;j++) state.a[j]=random64();
        uint32_t key=__get_PRIMASK(); __disable_irq();
        uint32_t empty=bench_process_empty(state.a,64);
        uint32_t total=bench_process(state.a,64);
        /* All 24 rounds of the last call in the batch were timestamped.
         * Store cycle differences only after the timed batch has ended. */
        uint32_t input=phase_ticks[1]-phase_ticks[0];
        uint32_t init=phase_ticks[32]-phase_ticks[1];
        uint32_t theta=0,chi=0,control=0;
        for(unsigned n=24;n>=1;n--) {
            theta+=phase_ticks[40+n]-phase_ticks[8+n];
            chi+=phase_ticks[72+n]-phase_ticks[40+n];
            control+=(n>1?phase_ticks[8+n-1]:phase_ticks[2])-phase_ticks[72+n];
        }
        uint32_t iota=phase_ticks[3]-phase_ticks[2];
        uint32_t output=phase_ticks[4]-phase_ticks[3];
        uint32_t span=phase_ticks[4]-phase_ticks[0];
        phase_calibrate();
        uint32_t cff=phase_ticks[105]-phase_ticks[104];
        uint32_t cfi=phase_ticks[107]-phase_ticks[105];
        uint32_t cii=phase_ticks[108]-phase_ticks[107];
        uint32_t cif=phase_ticks[109]-phase_ticks[108];
        __set_PRIMASK(key);
        if(s>=5) {
            uint32_t *p=phase_samples[s-5];
            p[0]=total-empty; p[1]=input; p[2]=init; p[3]=theta; p[4]=chi;
            p[5]=control; p[6]=iota; p[7]=output; p[8]=span;
            p[9]=cff; p[10]=cii; p[11]=(cfi<<16)|cif;
        }
    }
    printf("PHASE_BEGIN variant=%s samples=100 batch=64 last_call_rounds=24 taps=%u\n","PROFILE_VARIANT",PROFILE_TAPS);
    for(unsigned s=0;s<100;s++) {
        uint32_t *p=phase_samples[s];
        printf("PHASE_SAMPLE i=%u total=%u input=%u init=%u theta=%u chi=%u control=%u iota=%u output=%u span=%u cff=%u cii=%u cfi=%u cif=%u\n",
            s,p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11]>>16,p[11]&65535);
    }
    printf("PHASE_DONE\n");
}
