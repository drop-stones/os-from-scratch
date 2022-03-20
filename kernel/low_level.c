
unsigned char port_byte_in(unsigned short port) {
  unsigned char result;
  asm(".intel_syntax noprefix\n"
      "in al, dx\n"
      : "=a" (result)   // put AL in variable 'result'
      : "d" (port)      // load DX with port
  );
  return result;
}

void port_byte_out(unsigned short port, unsigned char data) {
  asm(".intel_syntax noprefix\n"
      "out dx, al\n"
      :
      : "a" (data), "d" (port)
  );
}

unsigned short port_word_in(unsigned short port) {
  unsigned short result;
  asm(".intel_syntax noprefix\n"
      "in ax, dx\n"
      : "=a" (result)   // put AL in variable 'result'
      : "d" (port)      // load DX with port
  );
  return result;
}

void port_word_out(unsigned short port, unsigned short data) {
  asm(".intel_syntax noprefix\n"
      "out dx, ax\n"
      :
      : "a" (data), "d" (port)
  );
}