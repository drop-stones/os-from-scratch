#include "low_level.h"
#include "screen.h"

void main() {
  clear_screen();
  for (int i = 0; i < 15; i++) {
    print("Hello World from kernel!\n");
  }
  for (int i = 0; i < 15; i++) {
    print("Good Bye!!!\n");
  }
}