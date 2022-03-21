#include "util.h"

// Copy bytes from one place to another
void memory_copy(char *src, char *dst, int num_bytes) {
  for (int i = 0; i < num_bytes; i++) {
    dst[i] = src[i];
  }
}