cmake_minimum_required(VERSION 3.16)

project("OS-from-scratch"
  DESCRIPTION "Create OS for x86 from scratch"
  LANGUAGES C ASM_NASM
)

set(CMAKE_C_COMPILER "/usr/local/bin/clang")
set(CMAKE_NASM_LINK_EXECUTABLE "ld <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")

add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/bootloader.bin
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/bootloader.asm
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/io.asm
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/disk_load.asm
  COMMAND nasm -I ${CMAKE_CURRENT_SOURCE_DIR} -f bin ${CMAKE_CURRENT_SOURCE_DIR}/bootloader.asm -o bootloader.bin
)
add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/kernel.bin
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/sample.asm
  COMMAND nasm -f bin ${CMAKE_CURRENT_SOURCE_DIR}/sample.asm -o kernel.bin
)
add_custom_target(BootDisk ALL
  SOURCES ${CMAKE_CURRENT_BINARY_DIR}/bootloader.bin ${CMAKE_CURRENT_BINARY_DIR}/kernel.bin
  COMMAND dd if=/dev/zero of=disk.img bs=512 count=2880
  COMMAND dd conv=notrunc if=${CMAKE_CURRENT_BINARY_DIR}/bootloader.bin of=disk.img bs=512 count=1 seek=0
  COMMAND dd conv=notrunc if=${CMAKE_CURRENT_BINARY_DIR}/kernel.bin of=disk.img bs=512 count=2 seek=1
)