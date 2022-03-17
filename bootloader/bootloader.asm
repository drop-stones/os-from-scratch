;*************************************************
; bootloader.asm
;   A simple bootloader
;*************************************************

[bits 16]     ; tell NASM this is 16 bit code
[org 0x7c00]  ; tell NASM to start outputting stuff at offset 0x7c00
              ; All labels are added 0x7c00 for simplicity
              ; BIOS always load boot sector to the address 0x7c00

start:
  jmp boot

boot:
  mov [BOOT_DRIVE], dl  ; BIOS stores our boot drive in DL

  mov bp, 0x9000  ; Here we set our stack safely
  mov sp, bp

  mov si, MSG_REAL_MODE
  call Print

  mov ax, 0x50    ; ES:BX = pointer to buffer
  mov es, ax      ; ES = 0x50
  xor bx, bx      ; bx = 0x00

  mov dh, 2             ; read 5 sectors
  mov dl, [BOOT_DRIVE]  ; drive number
  call LoadDisk

  mov al, [0x500]       ; al = 0xda
  call PutHexChar       ; print al as hex
  mov al, [0x500 + 512] ; al = 0xce
  call PutHexChar       ; print al as hex

  call SwitchIntoPM

  hlt

%include "io.asm"
%include "disk_load.asm"
%include "gdt.asm"
%include "switch_into_pm.asm"

[bits 32]
BEGIN_PM:
  mov esi, MSG_PROT_MODE
  call PrintPM
  hlt

; Global variables
BOOT_DRIVE db 0
MSG_REAL_MODE db "Welcome to My Operating System in 16-bit Real Mode!", 0xa, 0xd, 0x0
MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode!", 0xa 0xd, 0x0

times 510 - ($-$$) db 0   ; We have to be 512 bytes. Clear the rest of the bytes with 0
                          ; '$' evaluates to the current assembly position
                          ; '$$' evalutates to the beginning of the current section
dw 0xaa55                 ; Boot Signiture which tell BIOS that this is a boot block.