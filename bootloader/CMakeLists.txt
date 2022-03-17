add_custom_command(
  OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/bootloader.bin
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/bootloader.asm
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/io.asm
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/disk_load.asm
  COMMAND nasm -I ${CMAKE_CURRENT_SOURCE_DIR} -f bin ${CMAKE_CURRENT_SOURCE_DIR}/bootloader.asm -o bootloader.bin
)

add_custom_target(BootloaderObj ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/bootloader.bin)