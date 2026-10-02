/* Development-mode FSBL in AXI SRAM2. No internal/external Flash writes. */
ENTRY(Reset_Handler)
MEMORY {
  ROM (rx) : ORIGIN = 0x34180400, LENGTH = 255K
  RAM (rw) : ORIGIN = 0x341C0000, LENGTH = 252K
  MAILBOX (rw) : ORIGIN = 0x341FF000, LENGTH = 4K
}
_estack = ORIGIN(RAM) + LENGTH(RAM);
_sstack = _estack - 0x18000;
SECTIONS {
  .isr_vector : { KEEP(*(.isr_vector)) . = ALIGN(4); } > ROM
  .text : {
    *(.text .text*) *(.glue_7 .glue_7t) *(.eh_frame)
    KEEP(*(.init)) KEEP(*(.fini)) . = ALIGN(4); _etext = .;
  } > ROM
  .rodata : { *(.rodata .rodata*) . = ALIGN(4); } > ROM
  .ARM.extab : { *(.ARM.extab* .gnu.linkonce.armextab.*) } > ROM
  .ARM.exidx : { __exidx_start = .; *(.ARM.exidx*) __exidx_end = .; } > ROM
  .preinit_array : {
    PROVIDE_HIDDEN(__preinit_array_start = .);
    KEEP(*(.preinit_array*)) PROVIDE_HIDDEN(__preinit_array_end = .);
  } > ROM
  .init_array : {
    PROVIDE_HIDDEN(__init_array_start = .);
    KEEP(*(SORT(.init_array.*))) KEEP(*(.init_array*))
    PROVIDE_HIDDEN(__init_array_end = .);
  } > ROM
  .fini_array : {
    PROVIDE_HIDDEN(__fini_array_start = .);
    KEEP(*(SORT(.fini_array.*))) KEEP(*(.fini_array*))
    PROVIDE_HIDDEN(__fini_array_end = .);
  } > ROM
  .gnu.sgstubs : { . = ALIGN(32); *(.gnu.sgstubs*) } > ROM
  _sidata = LOADADDR(.data);
  .data : { . = ALIGN(4); _sdata = .; *(.data .data*) . = ALIGN(4); _edata = .; } > RAM AT > ROM
  .bss (NOLOAD) : {
    . = ALIGN(8); _sbss = .; __bss_start__ = .;
    *(.bss .bss*) *(COMMON) . = ALIGN(8); _ebss = .; __bss_end__ = .;
    PROVIDE(end = .); PROVIDE(_end = .);
  } > RAM
  .bench_results (NOLOAD) : { KEEP(*(.bench_results)) } > MAILBOX
  .ARM.attributes 0 : { *(.ARM.attributes) }
}
ASSERT(_ebss <= _sstack, "Insufficient stack space")
ASSERT(SIZEOF(.bench_results) == 2560, "Unexpected M55 mailbox layout")
