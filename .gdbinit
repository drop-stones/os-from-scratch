target remote localhost:1234
# symbol-file bootloader/bootloader.sym
# breakpoint boot
# continue
symbol-file build/os/kernel.sym
break main
continue
layout asm
layout reg