
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
; PutHexChar()
;   - Prints a character as hexadecimal to screen
; AL = Character to print
; BL = text color
; CX = number of times character is dispaly
;***************************************;
PutHexChar:
  cmp al, 0xa
  jl .put_number
  add al, 0x57      ; change 0xa into 'a' in ascii
  call PutChar
  jmp .put_hex_end
.put_number:
  add al, 0x30      ; change 0x1 into '1' in ascii
  call PutChar
.put_hex_end:
  ret

;***************************************;
; Print()
;   - Print a string
; DS:SI = 0 terminated string
;***************************************;
Print:
.print_loop:
  lodsb             ; load next byte from string from SI to AL
  cmp al, 0         ; al =? 0 (null-terminated checking)
  je  .print_done

  call PutChar      ; put one character
  jmp .print_loop
.print_done:
  ret

;***************************************;
; PrintHex()
;   - Print a string as hexadecimal
; DS:SI = 0 terminated string
;***************************************;
PrintHex:
  mov al, '0'
  call PutChar
  mov al, 'x'
  call PutChar

.print_hex_loop:
  lodsb
  cmp al, 0
  je .print_hex_done

  mov bl, al          ; save al into bl
  shr al, 4           ; al >> 4
  call PutHexChar     ; print upper numbers as hex

  and bl, 0xf         ; clear upper numbers
  mov al, bl
  call PutHexChar

  jmp .print_hex_loop

.print_hex_done:
  ret