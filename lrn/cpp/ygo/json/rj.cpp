/**
 * @file rj.cpp
 * @author Jianer Cong
 * @brief parse json into cards
 */

#include <vector>
#include <string>
#include <cstring>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include "rj.h"


#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif

#ifdef _WIN32
#define PAUSE cout.flush(); Sleep(100)
#else
// sleep for 5e5 micro secs
#define PAUSE cout.flush(); usleep(1e5)
#endif

using std::string;
using std::ifstream;
using std::ostream;
using std::cout;
using std::endl;
using std::cerr;
using std::vector;

inline void report(const char* s);
void test_read_cards_from_file(void){
  report("read_cards_from_file");
  vector<cinfo> v;
  read_cards_from_file("cards-en.json", v);
  cout << "🐸 🐸Showing cards:\n";
  for (cinfo s : v){
    cout << "🐸The card read: \n"
         << s;
  }
}

cinfo parse_next_card(ifstream &j);
void read_cards_from_file(const char *filename, vector<cinfo> &v){
  ifstream fin;
  fin.open(filename);
  if (!fin.is_open()){
    cout << "Error reading " << filename << endl;
    fin.clear();
    exit(EXIT_FAILURE);
  }
  cout << "Reading from "<< filename << endl;
  // Keep reading char from file, if it's an '{', parse a card, if it's EOF
  // => done.
  char c;
  while (fin.get(c)){
    if (c == '{'){
      v.push_back(parse_next_card(fin));
    }else
      continue;
  }
  fin.close();
};

string& wrap(string& s, int w = 60);

ostream& operator<<(ostream& os, cinfo c)
{
  os << "\tname : " << c.name << endl;
  os << "\tid : " << c.id << endl;
  os << "\ttext:----------------------\n"
     << wrap(c.text, 60) << endl;
  return os;
}

void test_parse_next_card(void){
  ifstream fin;
  const char *filename = "cards-en.json";
  fin.open(filename);
  if (!fin.is_open()){
    cout << "Error reading " << filename << endl;
    fin.clear();
    exit(EXIT_FAILURE);
  }
  cout << "Reading from "<< filename << endl;
  for (int i =0; i < 3 ; i++){
    cinfo c = parse_next_card(fin);
    cout << "\n The card parsed:\n" << c;
  }
  fin.close();
}



string get_next_string(ifstream &j);
int get_next_int(ifstream &j);
/**
 * @brief Parse the card info stored in j and return the card info object.
 * @param j the string containing the json text that describe the card object.
 * This function will simply moves the head in ifstream j to the next colon(:)
 * and then parse a int until an comma (,). This gives an id.
 *
 * Next, it do the following twice:
 *
 * Find the next colon (:), parse a string enclosed in double quotes("").
 *
 * It stops just after it gets a '}' from j. The client program can go to a '{'
 * and call this function.
 */
cinfo parse_next_card(ifstream &j){
  char c;
  cinfo s;
  cout << "Parsing card: \n";
  j.get(c);
  for(;c != '}'; j.get(c)){
    PAUSE;
    if (isspace(c)){
      cout << '.';
      continue;
    }
    if (c == '#'){
      while (j.get() != '\n')
        continue;
    }
    s.id = get_next_int(j);
    s.name = get_next_string(j);
    s.text = get_next_string(j);
    c = j.get();
  }
  return s;
}

#define GO_TO_COMMA(J) while (j.get() != ':')   \
    continue

int get_next_int(ifstream &j){
  cout << "Getting next int: ";
  GO_TO_COMMA(j);
  char s[10];
  char c;
  j.get(c);
  for (int i = 0; c!=',';j.get(c)){
    PAUSE;
    if (isspace(c)){
      continue;
    }else{
      s[i++] = c;
    }
    cout << c << " ";
  }
  cout << endl;
  return atoi(s);
}

string get_next_string(ifstream &j){
  cout << "Getting next string\n";
  GO_TO_COMMA(j);
  string s;
  // go to the start of the string
  while (j.get() != '"')
    continue;
  // p is the previous char, c is the current char, we use this to distinguish " and \"
  char c;
  char p{'-'};
  c = j.get();
  // while we didn't reach the end of string.
  while (!(c == '"' && p != '\\')){
    s += c;
    p = c;
    c = j.get();
  }
  return s;
}


/**
 * @brief Wrap the string by inserting new-lines in it.
 * @param s the string to be wrapped, it is expected to have no newlines in it.
 * @param w the default width for this string, the resultant string will have
 * each line having at most w chars.
 */
string& wrap(string& s, int w ){
  if (s.length() < w)
    return s;
  for (int i = w; i < s.length(); i+=w){
    // go and search for whitespace until we have gone back more than w times.
    int p = i;
    for (; i > p - w; i--){
      if (isspace(s[i])){
#ifdef DEBUG
        cerr << "We found space at " << i << endl;

#endif
        s[i] = '\n';
        break;
      }
    }
    if (i == p-w){
      cerr << "Space not found for this turn\n";
      i = p;
    }
  }
  return s;
}

void test_wrap(void){
  report("wrap()");
  string s = " curl is a tool to transfer data from or to a server, using one of the supported protocols (DICT, FILE,  FTP,  FTPS,  GOPHER,  HTTP,  HTTPS, IMAP,  IMAPS,  LDAP,  LDAPS, POP3, POP3S, RTMP, RTSP, SCP, SFTP, SMB, SMBS, SMTP, SMTPS, TELNET and TFTP). The command is designed to  work without user interaction." ;
  wrap(s);
  cout << "Wrapped string: \n"
       << s
       << endl;
}

inline void report(const char* s){
  cout << "Testing " << s << " "<< string( 50 - strlen(s), '-') << endl;
}

#ifdef TEST
int main(int argc, char *argv[]){
  // test_wrap();
  // test_parse_next_card();
  test_read_cards_from_file();
return 0;
}
#endif
