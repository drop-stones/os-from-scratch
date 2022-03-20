cmake_minimum_required(VERSION 3.16)

project("OS-from-scratch"
  DESCRIPTION "Create OS for x86 from scratch"
  LANGUAGES C ASM_NASM
)

set(CMAKE_C_COMPILER "/usr/local/bin/clang")
set(CMAKE_NASM_LINK_EXECUTABLE "ld <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(DISK_IMG "disk.img")

add_custom_command(
  OUTPUT  ${DISK_IMG}
  DEPENDS ${PROJECT_BINARY_DIR}/lib/boot/bootloader.bin
  DEPENDS ${PROJECT_BINARY_DIR}/lib/kernel/kernel.elf
  COMMAND dd if=/dev/zero of=${DISK_IMG} bs=512 count=2880
  COMMAND dd conv=notrunc if=${PROJECT_BINARY_DIR}/lib/boot/bootloader.bin of=${DISK_IMG} bs=512 count=1 seek=0
  COMMAND dd conv=notrunc if=${PROJECT_BINARY_DIR}/lib/kernel/kernel.elf of=${DISK_IMG} bs=512 count=5 seek=1
)
add_custom_target(BootDisk ALL DEPENDS ${DISK_IMG})

add_custom_target(qemu
  DEPENDS BootDisk
  COMMAND qemu-system-x86_64 -machine q35 -fda ${DISK_IMG}
)
add_custom_target(qemu-debug
  DEPENDS BootDisk
  COMMAND qemu-system-x86_64 -machine q35 -fda ${DISK_IMG} -s -S
)

# message(STATUS "home = ${PROJECT_SOURCE_DIR}")
include_directories(${PROJECT_SOURCE_DIR}/include/kernel)

add_subdirectory("lib")
