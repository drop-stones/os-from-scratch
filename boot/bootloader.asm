;*************************************************
; bootloader.asm
;   A simple bootloader
;*************************************************

[bits 16]     ; tell NASM this is 16 bit code

start:
  jmp boot

boot:
  mov [BOOT_DRIVE], dl  ; BIOS stores our boot drive in DL

  mov bp, 0x9000  ; Set-up stack
  mov sp, bp

  mov si, MSG_REAL_MODE
  call Print

  call LoadKernel ; Load our kernel

  call SwitchIntoPM

  hlt

%include "io.asm"
%include "disk_load.asm"
%include "gdt.asm"
%include "switch_into_pm.asm"

[bits 16]
LoadKernel:
  mov si, MSG_LOAD_KERNEL
  call Print

  cli                       ; clear all interrupt
  cld                       ; 

  mov ax, 0x50               ; Set-up parameters
  mov es, ax                ; ES:BX = pointer to buffer
  mov bx, 0x0
  mov dh, 15                ; DH = number of sectors to read
  mov dl, [BOOT_DRIVE]      ; DL = drive number
  call LoadDisk

  ret

[bits 32]
BEGIN_PM:
  mov esi, MSG_PROT_MODE
  call PrintPM

  call [KERNEL_OFFSET + 0x18]
  hlt

; Global variables
KERNEL_OFFSET equ 0x500  ; This is the memory offset to which we will load kernel
BOOT_DRIVE db 0
MSG_REAL_MODE db "Welcome to My Operating System in 16-bit Real Mode!", 0xa, 0xd, 0x0
MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode!", 0xa 0xd, 0x0
MSG_LOAD_KERNEL db "Loading kernel into memory ...", 0xa, 0xd, 0x0

times 510 - ($-$$) db 0   ; We have to be 512 bytes. Clear the rest of the bytes with 0
                          ; '$' evaluates to the current assembly position
                          ; '$$' evalutates to the beginning of the current section
dw 0xaa55                 ; Boot Signiture which tell BIOS that this is a boot block.