/* High 256 KiB slot only; original boot image is not overwritten.
 * Slot must be backed up and verified erased before programming. */
ENTRY(Reset_Handler)
MEMORY {
  FLASH (rx) : ORIGIN = 0x081C0000, LENGTH = 256K
  MAILBOX (rw) : ORIGIN = 0x20030000, LENGTH = 64K
  RAM (xrw) : ORIGIN = 0x20040000, LENGTH = 384K
}
_estack = ORIGIN(RAM) + LENGTH(RAM);
SECTIONS {
  .isr_vector : { . = ALIGN(512); KEEP(*(.isr_vector)) } > FLASH
  .text : {
    *(.text .text*) *(.glue_7 .glue_7t) *(.eh_frame)
    KEEP(*(.init)) KEEP(*(.fini)) . = ALIGN(4); _etext = .;
  } > FLASH
  .rodata : { *(.rodata .rodata*) . = ALIGN(4); } > FLASH
  .ARM.extab : { *(.ARM.extab* .gnu.linkonce.armextab.*) } > FLASH
  .ARM.exidx : { __exidx_start = .; *(.ARM.exidx*) __exidx_end = .; } > FLASH
  .preinit_array : {
    PROVIDE_HIDDEN(__preinit_array_start = .);
    KEEP(*(.preinit_array*)) PROVIDE_HIDDEN(__preinit_array_end = .);
  } > FLASH
  .init_array : {
    PROVIDE_HIDDEN(__init_array_start = .);
    KEEP(*(SORT(.init_array.*))) KEEP(*(.init_array*))
    PROVIDE_HIDDEN(__init_array_end = .);
  } > FLASH
  .fini_array : {
    PROVIDE_HIDDEN(__fini_array_start = .);
    KEEP(*(SORT(.fini_array.*))) KEEP(*(.fini_array*))
    PROVIDE_HIDDEN(__fini_array_end = .);
  } > FLASH
  _sidata = LOADADDR(.data);
  .data : { . = ALIGN(4); _sdata = .; *(.data .data*) . = ALIGN(4); _edata = .; } > RAM AT > FLASH
  .bss (NOLOAD) : {
    . = ALIGN(8); _sbss = .; __bss_start__ = .;
    *(.bss .bss*) *(COMMON) . = ALIGN(8); _ebss = .; __bss_end__ = .;
  } > RAM
  .heap_stack (NOLOAD) : {
    PROVIDE(end = .); PROVIDE(_end = .); . += 0x10000;
  } > RAM
  .bench_results (NOLOAD) : { KEEP(*(.bench_results)) } > MAILBOX
  .ARM.attributes 0 : { *(.ARM.attributes) }
}
ASSERT(SIZEOF(.bench_results) == 2536, "Unexpected benchmark mailbox layout")
