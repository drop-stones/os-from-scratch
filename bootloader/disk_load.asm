;*************************************************
; disk_load.asm
;   Load sectors from floppy disk
;*************************************************

DISK_ERR_MSG db "Disk read error!", 0x0

;***************************************;
; LoadDisk()
;   - Load sectors from disk drive
; DH = number of sectors to read (1-128 dec.)
; DL = drive number (0=A:, 1=2nd floppy, 80h=drive 0, 81h=drive 1)
; ES:BX = pointer to buffer
;***************************************;
LoadDisk:
  push dx         ; save dh onto stack

  mov al, dh      ; Read DH sectors
  mov ch, 0x00    ; Select cylinder 0
  mov dh, 0x00    ; Select head 0
  mov cl, 0x02    ; Start reading from second sector

  mov ah, 0x02    ; BIOS read sector function
  int 0x13        ; BIOS interrupt

  jc .disk_error  ; jump if error (i.e. carry flag set)

  pop dx          ; restore DX from stack
  cmp dh, al      ; if AL (sectors read) != DH (sectors expected)
  jne .disk_error ;   display error message
  ret

.disk_error:
  mov si, DISK_ERR_MSG
  call Print
  hlt
