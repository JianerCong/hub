void cipher_decode(char *text)
{
  for (int i=0; text[i] != 0x0; i++) {
    text[i]--;
  }

} // end of cipher_decode
