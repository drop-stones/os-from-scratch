;*************************************************
; bootloader.asm
; A simple bootloader
;*************************************************

bits 16     ; tell NASM this is 16 bit code
org 0x7c00  ; tell NASM to start outputting stuff at offset 0x7c00
            ; All labels are added 0x7c00 for simplicity
            ; BIOS always load boot sector to the address 0x7c00

start:
  jmp boot

boot:
  mov si, HELLO_MSG
  call Print
  mov si, msg
  call Print
  mov si, BYE_MSG
  call Print

  cli ; no interrupts
  cld ; all that we need to init
  hlt ; halt the system


%include "io.asm"

msg db "Welcome to My Operating System!", 0xa, 0xd, 0x0
HELLO_MSG db "Hello World!", 0xa, 0xd, 0x0
BYE_MSG db "Goodbye!", 0xa, 0xd, 0x0

times 510 - ($-$$) db 0   ; We have to be 512 bytes. Clear the rest of the bytes with 0
                          ; '$' evaluates to the current assembly position
                          ; '$$' evalutates to the beginning of the current section
dw 0xAA55                 ; Boot Signiture which tell BIOS that this is a boot block.