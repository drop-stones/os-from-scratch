#include <stdint.h>
#include "util.h"
#include "low_level.h"
#include "screen.h"

// Colour VGA text mode
#define VIDEO_ADDRESS 0xb8000
#define MAX_HEIGHT 25
#define MAX_WIDTH 80

// Attrubute bytes for color scheme
#define WHITE_ON_BLACK 0x0f

// Screen device I/O ports
#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5

// Calculate offset from column and row
int get_screen_offset(int col, int row) {
  return (col * MAX_WIDTH + row) * 2;
}

// Get currenty cursor position in Text mode
int get_cursor(void) {
  int offset;
  port_byte_out(REG_SCREEN_CTRL, 0x0e);
  offset = port_byte_in(REG_SCREEN_DATA) << 8;
  port_byte_out(REG_SCREEN_CTRL, 0x0f);
  offset += port_byte_in(REG_SCREEN_DATA);
  return offset * 2;
}

// Set cursor position in Text mode
void set_cursor(int offset) {
  offset /= 2;

  port_byte_out(REG_SCREEN_CTRL, 0x0e);
  port_byte_out(REG_SCREEN_DATA, (uint8_t)(offset >> 8));
  port_byte_out(REG_SCREEN_CTRL, 0x0f);
  port_byte_out(REG_SCREEN_DATA, (uint8_t)(offset & 0xff));
}

// Advance the text cursor, scrolling the video buffer if necessary
int handle_scrolling(int cursor_offset) {
  // If the cursor is within the screen, return it unmodified
  if (cursor_offset < MAX_WIDTH * MAX_HEIGHT * 2) {
    return cursor_offset;
  }

  // Shift up all Texts in screen
  for (int i = 0; i < MAX_HEIGHT; i++) {
    memory_copy((char *)(get_screen_offset(i+1, 0) + VIDEO_ADDRESS),
                (char *)(get_screen_offset(i, 0) + VIDEO_ADDRESS),
                MAX_WIDTH * 2);
  }

  // Blank the last line by settings all bytes to 0
  char *last_line = (char *)(get_screen_offset(MAX_HEIGHT - 1, 0) + VIDEO_ADDRESS);
  for (int i = 0; i < MAX_WIDTH * 2; i++) {
    last_line[i] = 0;
  }

  // Move cursor position
  cursor_offset -= MAX_WIDTH * 2;
  return cursor_offset;
}

// Print a char on the screen at (col, row), or at cursor position
void print_char(char character, int col, int row, char attribute_byte) {
  unsigned char *vidmem = (unsigned char *) VIDEO_ADDRESS;

  if (attribute_byte == 0) {
    attribute_byte = WHITE_ON_BLACK;
  }

  int offset;
  if (col >= 0 && row >= 0) {
    offset = get_screen_offset(col, row);
  } else {
    offset = get_cursor();
    row = offset % (2 * MAX_WIDTH);
    col = offset / (2 * MAX_WIDTH);
  }

  if (character == '\n') {
    offset = get_screen_offset(col + 1, 0);
  } else {
    vidmem[offset] = character;
    vidmem[offset + 1] = attribute_byte;
    offset += 2;
  }

  offset = handle_scrolling(offset);
  set_cursor(offset);
}

// Print string on the screen at (col, row), or at cursor position
void print_at(char *msg, int col, int row) {
  if (col >= 0 && row >= 0) {
    set_cursor(get_screen_offset(col, row));
  }

  int i = 0;
  while(msg[i] != '\0') {
    print_char(msg[i++], col, row, WHITE_ON_BLACK);
  }
}

// Print msg at current position
void print(char *msg) {
  print_at(msg, -1, -1);
}

// Clear screen with ' ' and set cursor position at Left-Up corner.
void clear_screen(void) {
  for (int row = 0; row < MAX_WIDTH; row++) {
    for (int col = 0; col < MAX_HEIGHT; col++) {
      print_char(' ', col, row, WHITE_ON_BLACK);
    }
  }

  set_cursor(get_screen_offset(0, 0));
}
