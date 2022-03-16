;*************************************************
; bootloader.asm
; A simple bootloader
;*************************************************

bits 16     ; tell NASM this is 16 bit code
org 0x7c00  ; tell NASM to start outputting stuff at offset 0x7c00

start:
  jmp boot

boot:
  cli ; no interrupts
  cld ; all that we need to init
  hlt ; halt the system

times 510 - ($-$$) db 0   ; We have to be 512 bytes. Clear the rest of the bytes with 0
                          ; '$' evaluates to the current assembly position
                          ; '$$' evalutates to the beginning of the current section
dw 0xAA55                 ; Boot Signiture which tell BIOS that this is a boot block.