
;***************************************;
; SwitchIntoPM()
;   - Switch into 32-bit protected mode
;***************************************;
[bits 16]

SwitchIntoPM:
  cli                     ; clear (ignore any future) interrupts
                          ; current IVT that BIOS set up is meaningless in protected mode
  lgdt [gdt_descriptor]   ; load GDT into GDTR
  mov eax, cr0            ; switch into protected mode
  or eax, 0x1             ;   by setting the first bit of CR0 (control register)
  mov cr0, eax

  jmp CODE_SEG:InitPM     ; make a far jump to our 32-bit code.
                          ; This forces the CPU to flush its cache of pre-fetched and real-mode decoded instructions

;***************************************;
; InitPM()
;   - Initialize registers and the stack one in PM
;***************************************;
[bits 32]

InitPM:
  mov ax, DATA_SEG        ; Now in PM, our old segments are meaningless
  mov ds, ax              ; so we point our segment registers to new GDT segments
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000        ; Update our stack position so it is right
  mov esp, ebp            ; at the top of the free space

  call BEGIN_PM
