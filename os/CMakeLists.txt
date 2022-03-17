add_custom_command(
  OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/kernel.bin
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/sample.asm
  COMMAND nasm -f bin ${CMAKE_CURRENT_SOURCE_DIR}/sample.asm -o kernel.bin
)

add_custom_target(KernelObj ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/kernel.bin)