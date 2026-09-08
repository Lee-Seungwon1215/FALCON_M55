/* STM32N657 FSBL image loaded entirely into AXI SRAM2 in development mode. */
ENTRY(Reset_Handler)

MEMORY
{
  ROM (xrw) : ORIGIN = 0x34180400, LENGTH = 255K
  RAM (xrw) : ORIGIN = 0x341C0000, LENGTH = 256K
}

_Min_Heap_Size = 0;
_Min_Stack_Size = 0x18000; /* 96 KiB; Falcon-512 signing uses a 36 KiB tmp. */
_estack = ORIGIN(RAM) + LENGTH(RAM);
_sstack = _estack - _Min_Stack_Size;

SECTIONS
{
  .isr_vector :
  {
    . = ALIGN(4);
    KEEP(*(.isr_vector))
    . = ALIGN(4);
  } > ROM

  .text :
  {
    . = ALIGN(4);
    *(.text .text*)
    *(.glue_7 .glue_7t)
    *(.eh_frame)
    *(.RamFunc .RamFunc*)
    KEEP(*(.init))
    KEEP(*(.fini))
    . = ALIGN(4);
    _etext = .;
  } > ROM

  .rodata :
  {
    . = ALIGN(4);
    *(.rodata .rodata*)
    . = ALIGN(4);
  } > ROM

  .ARM.extab (READONLY) :
  {
    *(.ARM.extab* .gnu.linkonce.armextab.*)
  } > ROM

  .ARM (READONLY) :
  {
    __exidx_start = .;
    *(.ARM.exidx*)
    __exidx_end = .;
  } > ROM

  .preinit_array (READONLY) :
  {
    PROVIDE_HIDDEN(__preinit_array_start = .);
    KEEP(*(.preinit_array*))
    PROVIDE_HIDDEN(__preinit_array_end = .);
  } > ROM

  .init_array (READONLY) :
  {
    PROVIDE_HIDDEN(__init_array_start = .);
    KEEP(*(SORT(.init_array.*)))
    KEEP(*(.init_array*))
    PROVIDE_HIDDEN(__init_array_end = .);
  } > ROM

  .fini_array (READONLY) :
  {
    PROVIDE_HIDDEN(__fini_array_start = .);
    KEEP(*(SORT(.fini_array.*)))
    KEEP(*(.fini_array*))
    PROVIDE_HIDDEN(__fini_array_end = .);
  } > ROM

  _sidata = LOADADDR(.data);
  .data :
  {
    . = ALIGN(4);
    _sdata = .;
    *(.data .data*)
    . = ALIGN(4);
    _edata = .;
  } > RAM AT > ROM

  .noncacheable :
  {
    . = ALIGN(32);
    __snoncacheable = .;
    KEEP(*(.noncacheable))
    . = ALIGN(32);
    __enoncacheable = .;
  } > RAM

  .gnu.sgstubs :
  {
    . = ALIGN(4);
    *(.gnu.sgstubs*)
    . = ALIGN(4);
  } > ROM

  .bss (NOLOAD) :
  {
    . = ALIGN(8);
    _sbss = .;
    __bss_start__ = .;
    *(.bss .bss*)
    *(COMMON)
    . = ALIGN(8);
    _ebss = .;
    __bss_end__ = .;
  } > RAM

  ._user_heap_stack (NOLOAD) :
  {
    . = ALIGN(8);
    PROVIDE(end = .);
    PROVIDE(_end = .);
    . += _Min_Heap_Size;
    . += _Min_Stack_Size;
    . = ALIGN(8);
  } > RAM

  .ARM.attributes 0 : { *(.ARM.attributes) }
}
