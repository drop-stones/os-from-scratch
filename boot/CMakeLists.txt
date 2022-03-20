add_custom_command(
  OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/bootloader.bin
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/bootloader.asm
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/io.asm
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/disk_load.asm
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/gdt.asm
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/switch_into_pm.asm
  COMMAND nasm -I ${CMAKE_CURRENT_SOURCE_DIR} -f elf ${CMAKE_CURRENT_SOURCE_DIR}/bootloader.asm -g -o bootloader.o
  COMMAND ld -m elf_i386 -T ${CMAKE_CURRENT_SOURCE_DIR}/bootloader.lds bootloader.o -o bootloader.elf
  COMMAND objcopy --only-keep-debug bootloader.elf bootloader.sym
  COMMAND objcopy -O binary bootloader.elf bootloader.bin
)

add_custom_target(BootloaderObj ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/bootloader.bin)