;*************************************************
; gdt.asm
;   Global Descriptor Table
;*************************************************

; GDT
gdt_start:

gdt_null: ; the mandaroty null descriptor
  dd 0x0  ; 'dd' means define double word (i.e. 4 bytes)
  dd 0x0

gdt_code: ; the code segment descriptor
  dw 0xffff     ; Limit (bits 0-15)
  dw 0x0        ; Base (bits 0-15)
  db 0x0        ; Base (bits 16-23)
  db 10011010b  ; 1st flags, type flags
  db 11001111b  ; 2nd flags, Limit (bits 16-19)
  db 0x0        ; Base (bits 24-31)

gdt_data: ; the data segment descriptor
  dw 0xffff     ; Limit (bits 0-15)
  dw 0x0        ; Base (bits 0-15)
  db 0x0        ; Base (bits 16-23)
  db 10010010b  ; 1st flags, type flags
  db 11001111b  ; 2nd flags, Limit (bits 16-19)
  db 0x0        ; Base (bits 24-31)

gdt_end:

; GDT descriptor
gdt_descriptor:
  dw gdt_end - gdt_start - 1
  dd gdt_start

; GDT segment descriptor offsets
; 0x0 -> NULL; 0x08 -> CODE; 0x10 -> DATA
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
