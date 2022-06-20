void cipher_encode(char *text)
{
  for (int i=0; text[i] != 0x0; i++) {
    text[i]++;
  }

} // end of cipher_encode
