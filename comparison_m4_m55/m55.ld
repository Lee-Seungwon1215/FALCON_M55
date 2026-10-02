ENTRY(Reset_Handler)
MEMORY {
  ROM (rx) : ORIGIN = 0x34180400, LENGTH = 255K
  RAM (rw) : ORIGIN = 0x341C0000, LENGTH = 248K
  MAILBOX (rw) : ORIGIN = 0x341FE000, LENGTH = 8K
}
_estack = ORIGIN(RAM) + LENGTH(RAM);
_sstack = _estack - 0x18000;
INCLUDE sections.ld
