// Dangerous, we should add volatile
/* int* PUT_ADDR = (int *)0xF000fff0; */
/* int* GET_ADDR = (int *)0xF000fff4; */
/* int* PUTINT_ADDR = (int *)0xF000fff4; */
/* int* FINISH_ADDR = (int *)0xF000fff8; */
int* PUT_ADDR = (int *)0x0000fff0;
int* PUTINT_ADDR = (int *)0x0000fff4;
int* GET_ADDR = (int *)0x0000fff4;
int* FINISH_ADDR = (int *)0x0000fff8;

int getchar() {
  return *GET_ADDR;
}

int putchar(int c) {
  *PUT_ADDR = c;
  return c;
}

int putint(int n) {
  *PUTINT_ADDR = n;
  return n;
}

int exit(int c) {
  *FINISH_ADDR = c;
  return c;
}
