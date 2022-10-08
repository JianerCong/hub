/**
 * @file hangman.cpp
 * @author Jianer Cong
 * @brief The guess-word game that illustrates some string methods
 */

#include <iostream>
#include <string>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <fstream>


#ifdef _WIN32
#include "C:\Users\congj\AppData\Roaming\Templates\mylib-shared.h"
#else
#include "/home/me/Templates/mylib-shared.h"
#endif


using std::string;
using std::cout;
using std::endl;
using std::cin;
// using std::tolower;
using std::vector;
using std::ifstream;
using std::cerr;



// The datebase that contains words seperated by space and \n

const string filename = "words.txt";

inline char ask(){
  static bool first = true;
  if (first)
    cout << "Do you wanna play a word game? <y/n>";
  else
    cout << "Do you wanna play again? <y/n>";

  char ans;
  cin >> ans;
  return tolower(ans);
}

void play(vector<string> W);


void skip_comment(ifstream &fin){
  while (fin.get() != '\n')
    continue;
}

string read_symbol(ifstream &fin){
  string s;
  fin >> s;
  // check if # exists.
  int pos;
  pos = (int) s.find('#');
  if (pos != string::npos){
    // cout << "Putting back over-read comments: ";
    string cm = s.substr(pos);
    // cout << cm << endl;
    for (int i = cm.length()-1; i >= 0; i--){
      fin.putback(cm[i]);
    }

    // Modify original string
    s = s.substr(0,pos-1);
  }
  return s;
}

vector<string> process_file2(ifstream &fin){
  string s;
  char c;
  vector<string> v;

  while (fin.get(c)){
    if (c == '#'){
      skip_comment(fin);
    }else if(isspace(c)){
      continue;
    }else{
      fin.putback(c);
      s = read_symbol(fin);
      v.push_back(s);
      // cout << "The word read: " << s << endl;
    }
  }
  cout << "File processed\n";
  return v;
}

void report_bad_file(string s){
  cerr << "Cannot open file " << s << endl;
}


/**
 * @brief Get the words declared in filename
 */
vector<string> getWords(){
  ifstream fin;
  fin.open(filename);
  if (!fin.is_open()){
    report_bad_file(filename);
    fin.clear();
    return {"apple","banana"};
  }
  return process_file2(fin);
}

int main(int argc, char *argv[]){
  // Set seed
  srand(time(0));
  vector<string> W = getWords();

  while(ask() == 'y'){
    play(W);
  };

  cout << "Okay. Bye.\n";
  return 0;
  }

/**
 * @brief Play the hangman game once for the words stored in W.
 * @param W the stored words.
 */
void play(vector<string> W){
  // the target string
  string t = W[std::rand() % W.size()];
  // the achieved string.
  string a = string(t.length(),'-');

  // Maximum number of bad-guesses
  int m = 6;
  char bad[m+1];                  //the bad chars.
  for (int i = 0; i < m ; i++)
    bad[i] = '-';
  bad[m] = '\0';

  char in;

  cout << "👏 Guess my secret words. It has "<< t.length()
       << " letters.\n\tYou can have at most "
       << m << " wrong guesses.\n";

  int loc;

  while(a != t && m > 0){
    cout << "Your word: " + a << endl
         << "Guess a letter: ";
    cin >> in;

    // If the char is found in bad.
    if (strchr(bad,in)){
      cout << "You have already guessed that letter, and it is " S_RED "wrong.\n" S_NOR;
      continue;
    }
    // If that is found in achieved string.
    int loc = a.find(in);
    if (loc != string::npos){
      cout << "You have already guessed that letter, and it is " S_GREEN "correct.\n" S_NOR;
      continue;
    }

    // Test if it is bad.
    loc = t.find(in);
    if (loc == string::npos){
      cout << S_RED "😭 Wrong guess.." S_NOR "You have " << m << " wrong chanes left.\n";
      bad[--m] = in;
      cout << "The wrong letters are " << bad << endl;
      continue;
    }else{
      cout << "🤣That's " S_GREEN "a good guess" S_NOR ".\n";
      // Add that char to a
      a[loc] = in;
      // Check if exist in the remaining string.
      loc = t.find(in,loc+1);
      while (loc != string::npos){
        a[loc] = in;
        loc = t.find(in,loc+1);
      }
    }
  }
  if (m > 0){
    cout << "You've made it 👍";
  }else{
    cout << "No chances any more, the word is: " << t << endl;
    cout << "Maybe it's too hard.💔";
  }
  cout << endl;
}
