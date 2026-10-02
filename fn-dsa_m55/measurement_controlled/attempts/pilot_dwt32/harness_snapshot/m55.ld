ENTRY(Reset_Handler)
MEMORY {
  ROM (rx) : ORIGIN = 0x34180400, LENGTH = 255K
  RAM (rw) : ORIGIN = 0x341C0000, LENGTH = 252K
  MAILBOX (rw) : ORIGIN = 0x341FF000, LENGTH = 4K
}
_estack = ORIGIN(RAM) + LENGTH(RAM);
_sstack = _estack - 0x18000;
INCLUDE sections.ld
