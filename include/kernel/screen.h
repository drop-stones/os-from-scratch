#ifndef SCREEN_H_
#define SCREEN_H_

void print_char(char character, int col, int row, char attribute_byte);
void print_at(char *msg, int col, int row);
void print(char *msg);
void clear_screen(void);

#endif