/**
 * @file rj.h
 * @author Jianer Cong
 * @brief function that parses the JSON card data
 */

#ifndef _READ_JSON_H
#define _READ_JSON_H

#include <string>
using std::string;
#include <iostream>
using std::ostream;
#include <vector>
using std::vector;

/**
 * @brief the card info
 */
struct cinfo {
  int id;
  string name;
  string text;
  friend ostream& operator<<(ostream& os, cinfo c);
};

/**
 * @brief read and parse the JSON file that contains cards data. Store the
 * results in v.
 * @param filename the JSON file file name.
 * @param v the vector in which the result will be pushed into.
 */
void read_cards_from_file(const char *filename, vector<cinfo> &v);

#endif
