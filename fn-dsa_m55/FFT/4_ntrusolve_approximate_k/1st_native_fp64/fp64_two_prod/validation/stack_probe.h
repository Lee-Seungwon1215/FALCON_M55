/* Diagnostic watermark, not production code. Paint only below current SP
 * with a 512-byte safety margin; never overwrite an active frame. */
#ifndef BENCH_HOST
extern unsigned char z_main_stack[];
static uintptr_t stack_paint_end;
__attribute__((noinline)) static void stack_probe_start(void)
{
    uintptr_t sp;__asm__ volatile("mov %0, sp":"=r"(sp));
    uintptr_t base=(uintptr_t)z_main_stack;
    if(sp<base+1024 || sp>base+CONFIG_MAIN_STACK_SIZE)return;
    stack_paint_end=sp-512;
    for(volatile unsigned char *p=z_main_stack;(uintptr_t)p<stack_paint_end;p++)*p=0xA5;
}
static int stack_probe_report(void)
{
    uintptr_t p=(uintptr_t)z_main_stack;
    if(!stack_paint_end)return 11;
    while(p<stack_paint_end && *(volatile unsigned char *)p==0xA5)p++;
    unsigned unused=(unsigned)(p-(uintptr_t)z_main_stack);
    printf("STACK_WATERMARK reserved=%u untouched_low=%u observed_used=%u\n",
        CONFIG_MAIN_STACK_SIZE,unused,CONFIG_MAIN_STACK_SIZE-unused);
    return unused<512?12:0;
}
#else
static void stack_probe_start(void){}
static int stack_probe_report(void){return 0;}
#endif
