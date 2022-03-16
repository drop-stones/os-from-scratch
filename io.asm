
;; constant and variable definitions
_CurX db 0
_CurY db 0

;***************************************;
; MovCursor()
;   - Move a cursor to a specific location on screen
; BL = X coordinate
; BH = Y coordinate
;***************************************;
MovCursor:
  mov ah, 0x2
  int 0x10        ; set up cursor position

  mov [_CurX], bl
  mov [_CurY], bh
  ret

;***************************************;
; PutChar()
;   - Prints a character to screen
; AL = Character to print
; BL = text color
; CX = number of times character is dispaly
;***************************************;
PutChar:
  mov ah, 0xe
  int 10h     ; print %al
  ret

;***************************************;
; Print()
;   - Print a string
; DS:SI = 0 terminated string
;***************************************;
Print:
.print_loop:
  lodsb             ; load next byte from string from SI to AL
  cmp  al, 0        ; al =? 0 (null-terminated checking)
  je  .print_done

  call PutChar      ; put one character
  jmp .print_loop
.print_done:
  ret
