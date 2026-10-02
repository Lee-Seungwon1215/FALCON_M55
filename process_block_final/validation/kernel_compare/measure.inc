/* Iota/control: 24 intervals, including the final taken branch. */
volatile uint32_t part_ticks[8192] __attribute__((aligned(32)));
extern void part_calibrate(void);
static uint32_t part_samples[100][7];
static int part_parse(uint32_t *sum, uint32_t *count, uint32_t *lo, uint32_t *hi) {
    *sum=0; *count=0; *lo=UINT32_MAX; *hi=0;
    for (unsigned i=0;i+3<8192;i+=4) {
        if (part_ticks[i+1]==3) return 0;
        if (part_ticks[i+1]!=1 || part_ticks[i+3]!=2) return 1;
        uint32_t d=part_ticks[i+2]-part_ticks[i];
        *sum+=d; ++*count;
        if(d<*lo) *lo=d;
        if(d>*hi) *hi=d;
    }
    return 2;
}
static int part_measure(void) {
    for(unsigned s=0;s<105;s++) {
        for(unsigned j=0;j<25;j++) state.a[j]=random64();
        uint32_t key=__get_PRIMASK(); __disable_irq();
        uint32_t empty=bench_process_empty(state.a,64);
        uint32_t total=bench_process(state.a,64);
        uint32_t raw=0,n=0,lo=0,hi=0;
        int err=0;
        if(PROFILE_CATEGORY) err=part_parse(&raw,&n,&lo,&hi);
        part_calibrate();
        uint32_t cal=0,cn=0,clo=0,chi=0;
        err|=part_parse(&cal,&cn,&clo,&chi);
        __set_PRIMASK(key);
        if(err || cn!=64) { printf("PART_FAIL parse=%d calibration_n=%u\n",err,cn); return 1; }
        if(s>=5) {
            uint32_t *p=part_samples[s-5];
            p[0]=total-empty; p[1]=raw; p[2]=n;
            p[3]=cal; p[4]=clo; p[5]=chi; p[6]=lo;
        }
    }
    printf("PART_BEGIN variant=%s samples=100 batch=64 category=%u\n","PROFILE_VARIANT",PROFILE_CATEGORY);
    for(unsigned s=0;s<100;s++) {
        uint32_t *p=part_samples[s];
        printf("PART_SAMPLE i=%u total=%u raw=%u n=%u calibration=%u cal_min=%u cal_max=%u interval_min=%u\n",
            s,p[0],p[1],p[2],p[3],p[4],p[5],p[6]);
    }
    printf("PART_DONE\n");
    return 0;
}
