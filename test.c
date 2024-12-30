#include <stdio.h>
#include <stdint.h>
#include "libpinedio-usb.h"

void callback_test() {
  printf("Got interrupt!\n");
}

int main(int argc, char** argv) {
  struct pinedio_inst inst = pinedio_struct_default();
  int ret;
  if ((ret = pinedio_init(&inst, NULL)) < 0) {
    return ret;
  }
#if 1
  for (int i = 0; i < 10; i++) {
#if 1
    uint8_t in[6] = {0x1D, 0x06, 0xBE };
    uint8_t out[6];
    pinedio_transceive(&inst, in, out, sizeof(out));
#else
    uint8_t in[] = {0x1D, 0x06, 0xBE };
    uint8_t out[3];
    pinedio_write_read(&inst, in, sizeof(in), out, sizeof(out));
#endif
    for (int j = 0; j < sizeof(out); j++) {
      printf("%02X ", out[j]);
    }
    printf("\n");
  }
#else
  pinedio_attach_interrupt(&inst, PINEDIO_INT_PIN_IRQ, PINEDIO_INT_MODE_RISING, callback_test);
  getchar();
#endif
  pinedio_deinit(&inst);
}