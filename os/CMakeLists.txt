add_library(KernelObj OBJECT
  ${CMAKE_CURRENT_SOURCE_DIR}/kernel.c
)
target_compile_options(KernelObj PRIVATE
  -ffreestanding -nostdlib -gdwarf-4 -m32 #-ggdb3
)

add_custom_command(
  OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/kernel.bin
  DEPENDS KernelObj
  # COMMAND ld -Ttext 0x1000 $<TARGET_OBJECTS:KernelObj> --oformat binary -o kernel.bin
  COMMAND ld -m elf_i386 -nmagic -T ${CMAKE_CURRENT_SOURCE_DIR}/kernel.lds $<TARGET_OBJECTS:KernelObj> -o kernel.bin
)
add_custom_target(KernelBin ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/kernel.bin)
