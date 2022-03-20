add_library(KernelObj OBJECT
  kernel.c
  low_level.c
)
target_compile_options(KernelObj PRIVATE
  -ffreestanding -nostdlib -gdwarf-4 -m32
)

set(KernelObj_DIR "${CMAKE_CURRENT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/KernelObj.dir")
# message(STATUS "out = ${KernelObj_DIR}")

add_custom_command(
  OUTPUT kernel.sym kernel.elf
  DEPENDS $<TARGET_OBJECTS:KernelObj>
  COMMAND ld -m elf_i386 -nmagic -T ${CMAKE_CURRENT_SOURCE_DIR}/kernel.lds -o kernel.elf ${KernelObj_DIR}/*.o
  # COMMAND ld -m elf_i386 -nmagic -T ${CMAKE_CURRENT_SOURCE_DIR}/kernel.lds $<TARGET_OBJECTS:KernelObj> -o kernel.elf
  COMMAND objcopy --only-keep-debug kernel.elf kernel.sym
  COMMAND objcopy --strip-debug kernel.elf
)
add_custom_target(KernelElf ALL DEPENDS kernel.elf)