/* Load at physical SRAM1 0x20000400, execute through SRAM1's ICode alias.
 * The controller enables volatile SYSCFG SRAM remapping before entry.
 * No ELF segment is programmed into Flash. */
ENTRY(Reset_Handler)
MEMORY {
  ROM (rx) : ORIGIN = 0x00000400, LENGTH = 191K
  RAM (rw) : ORIGIN = 0x20040000, LENGTH = 384K
  MAILBOX (rw) : ORIGIN = 0x20030000, LENGTH = 8K
}
_estack = ORIGIN(RAM) + LENGTH(RAM);
_sstack = _estack - 0x18000;
INCLUDE sections.ld
