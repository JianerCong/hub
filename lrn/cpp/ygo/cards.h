/**
 * @file cards.h
 * @author Jianer Cong
 * @brief the cards categories headers
 */

#ifndef CARDS_H_
#define CARDS_H_

class card {
 public:
  int id;                       /* the unique id */
  char* name;
  char* desc;                  /* the description string */
}

class mcard{
 public:
  /* monster card */
  int atk;
  int def;
}

class scard{
  /* settable card (magic + trap) */
}

class gcard : public scard{
 public:
  /* magic card */
}

class tcard : public scard{
  /* trap card */
}

#endif
