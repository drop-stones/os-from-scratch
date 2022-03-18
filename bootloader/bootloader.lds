PHDRS
{
  code PT_LOAD;
}

SECTIONS
{
  .text 0x7c00: { *(.text) } :code /* bootloader is loaded at 0x7c00 */
  .data       : { *(.data) }
}