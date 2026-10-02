/* Entire image in SRAM1; data and stack in SRAM3. Flash is untouched. */
ENTRY(Reset_Handler)
MEMORY {
  ROM (xrw) : ORIGIN = 0x20000000, LENGTH = 192K
  RAM (xrw) : ORIGIN = 0x20040000, LENGTH = 384K
}
_estack = ORIGIN(RAM) + LENGTH(RAM);
_Min_Stack_Size = 0x10000;
SECTIONS {
  .isr_vector : { . = ALIGN(512); KEEP(*(.isr_vector)) } > ROM
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
  _sidata = LOADADDR(.data);
  .data : { . = ALIGN(4); _sdata = .; *(.data .data*) . = ALIGN(4); _edata = .; } > RAM AT > ROM
  .bss (NOLOAD) : {
    . = ALIGN(8); _sbss = .; __bss_start__ = .;
    *(.bss .bss*) *(COMMON) . = ALIGN(8); _ebss = .; __bss_end__ = .;
  } > RAM
  .heap_stack (NOLOAD) : {
    PROVIDE(end = .); PROVIDE(_end = .); . += _Min_Stack_Size;
  } > RAM
  .ARM.attributes 0 : { *(.ARM.attributes) }
}
