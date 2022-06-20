/**
 * @file places.cpp
 * @author Jianer Cong
 * @brief Objects that makes up the dual field.
 */
// {{{ Headers

#include <iostream>
#include <string>
#include <vector>
#include <list>
#include <exception>
#include <unordered_map>


#ifdef _WIN32
#include "C:\Users\congj\AppData\Roaming\Templates\mylib2.hpp"
#else
#include "/home/me/Templates/mylib2.hpp"
#endif

using std::cout;
using std::endl;
using std::string;
using std::vector;
using std::ostream;
using std::list;
using std::invalid_argument;
using std::unordered_map;

typedef const *char cstr;
struct card_info{
  cstr name;
  cstr text;
  cstr type1;
  cstr type2;
  // card_info(cstr n,cstr t, cstr t1, cstr t2){};
};

unordered_map<string,card_info> card_data;
card_data["123"] = {"Kulibal", "The dark Kulibal", "mst"};
card_data["000"] = {"Winged Kulibal", "The angel Kulibal"};
card_data["111"] = {"Blue Eyes","The eyes of Blue-Eyes White Dragon"};

// }}}

// {{{ class card

class card {
public:
  string name;
  string text="";
  int id = 0;

  card(string n): name(n){cout << "\t card " << n << " initiazed\n";};
  card(string n, string t): card(n), text(t){};

  // {{{ cout << that reports name

  friend ostream& operator<<(ostream& os, card & c){
    os << "\t\tName :" << c.name ;
    return os;
  };

  // }}}
  // {{{ virtual destructor

  virtual ~card(){
    cout << "\tcard " S_BLUE << name << S_NOR " is gone.\n";
  };

  // }}}
};

// }}}
// {{{ class mst_card : public card [the monster card]

class mst_card : public card{
protected:
  // {{{ struct fig: the figure of a monster
  struct fig{
    int atk;
    int def;
    fig(int a, int d): atk(a), def(d){
      cout << "\t 1 figure made\n";
    }
    ~fig(){
      cout << "\t a figure is gone\n";
    }
  };
  // }}}
  fig* orig_fig;            //<! the original figure
  fig* curr_fig;             //<! the current figure (modify on change)
public:

  // {{{ friend ostream& operator<<(ostream& os, mst_card& m); 

  friend ostream& operator<<(ostream& os, mst_card& m){
    os << "\t\tMonster Card: \n"
      // Explicitly call the base operator<<
       << dynamic_cast<card &>(m)
       << "\t\tATK: " << m.curr_fig->atk
       << "\tDEF: " << m.curr_fig->def
       << endl;
    return os;
  };

  // }}}
  // {{{ virtual Constructor

   mst_card(string n, int atk, int def) : card(n){
    // call the base constructer and init figure
    orig_fig = curr_fig = new fig{atk,def};
  };

  // }}}
  // {{{ virtual Destructor

  virtual ~mst_card(){
    cout << "freeing memory for " << name << endl;
    if (orig_fig != curr_fig){
      cout << "\t**This monster has changed its original ATK and DEF.\n";
      delete orig_fig;
      delete curr_fig;
    }else{
      delete orig_fig;
    }
  };

  // }}}
};

void test_mst_card(){
  report("Testing monster card");
  {
    mst_card m1("Blue-Eyes", 3000, 2500);
    mst_card m2("Kulibal", 300, 200);
    cout << "Card 1: \n" << m1 << endl
         << "Card 2: \n" << m2 << endl;
  }
}
// }}}

// {{{class mgt_card : public card;

class mgt_card : public card{
  enum mag_type {nor,cnt,eqp,qck,fld,rit};
  enum trp_type {nor,cnt,ctr};
  bool is_magic;

  union mgt_card_type{
    mag_type m;
    trp_type t;
  };

  mgt_card_type type;

  // {{{ string (mag/trp)_type_2_string

  string mag_type_2_string(mag_type t){
    switch (t){
    case nor : return "Normal";
    case cnt : return "Continuous";
    case eqp : return "Equipment";
    case qck : return "Quick";
    case fld : return "Field";
    case rit : return "Ritual";
    };
    throw "Error in mag_type_2_string";
  };

  string trp_type_2_string(trp_type t){
    switch (t){
    case nor : return "Normal";
    case cnt : return "Continuous";
    case ctr : return "Counter";
    };
    throw "Error in trp_type_2_string";
  };

  // }}}
}

// }}}


// {{{ struct player

struct player{
  string name;
  int LP;
  static int count;
  player(int lp = 4000): LP(lp) {
    count++;
    char b[10];
    sprintf(b,"P%d",count);
    name = b;
  };
  player(string n, int lp = 4000): player(lp){
    name = n;
  };

  friend ostream& operator<<(ostream& os, const player& p){
    os << "Name: ";
    os.width(10);
    os << p.name << " LP: " << p.LP << endl;
    return os;
  };

  ~player(){
    cout << "Player " << name << " has left. " <<
      --count << " player(s) remains.\n";
  };

};
int player::count = 0;

void test_player(){
  report("player");
  {
    player p1,p2, p3("Yugi"), p4("Redy");
    cout << "Player 1: \t" << p1;
    cout << "Player 2: \t" << p2;
    cout << "Player 3: \t" << p3;
    cout << "Player 4: \t" << p4;
  }
}

// }}}

// {{{ class place

static const char* DEFAULT_NAME = "*Deck*";
class place{
protected:
  player *owner = NULL;
  string name = DEFAULT_NAME;
public:
  place(){};
  place(player *p, string n = DEFAULT_NAME):name(n), owner(p){};
  friend ostream& operator<<(ostream& os, const place& p){
    os << p.name << " owned by "
       << (p.owner ? p.owner->name : " No body" )<< endl;
    return os;
  };
  virtual bool is_empty() const = 0; // interface
};


/*
  Virtual class cannot be tested anymore.
 */

// void test_place(){
//   report("place");
//   place p1;
//   player pl1("Yuya");
//   place p2(&pl1);

//   cout << "Place 1:\n" << p1 << endl;
//   cout << "Place 2:\n" << p2 << endl;
// }

// }}}
// {{{ class mul_place : place that can hold many cards

class mul_place : public place{
  // class take can place many cards
public:
  enum mul_place_type {gv,deck,hand,ban};
  list<card*> cards;
  mul_place(mul_place_type t,player *p = NULL): type(t),
                                          place(p, mul_place_type_2_string(t)){};
  // {{{ bool is_empty() const

  bool is_empty() const{
    return cards.empty();
  }

  // }}}
  int size() const{return cards.size();};
  // {{{ T incr(T p, int i);

  /**
   * @brief Increment p, i times.
   */
  template<typename T>
  T incr(T p, int i){
    for (;i>0;i--){
      p++;
    }
    return p;
  }

  // }}}
#define Nth_(y,x) incr<list<card*>::iterator>(y.begin(), x)
  // {{{ card* drop_card(int i)


  card* drop_card(int i=1){
    if (i == 0)
      throw invalid_argument("You cannot drop the 0th card.");

    int loc = get_loc(i);
    card *tmp = *(Nth_(cards,loc)); // ≅ cards[i]
    cards.erase(Nth_(cards,loc));

    return tmp;
  }

  // }}}
  // {{{ void add_card(card *c, int i)

  void add_card(card *c, int i){
    int loc = get_loc(i);
    if (loc == size()){
      cards.push_back(c);
    }else{
      cards.insert(Nth_(cards,loc), c);
    }
  }

  // }}}
  // {{{ operator<<

  friend ostream& operator<<(ostream& os, const mul_place& m){

    os << dynamic_cast<const place&>(m);
    // Show cards:
    os << "Contents:\n";
    for (card* c : m.cards){
      os << '\t' << *c << endl;
    }
    return os;
    };

  // }}}


private:
  mul_place_type type;
  // {{{ string mul_place_type_2_string(mul_place_type p)

  string mul_place_type_2_string(mul_place_type p){
    switch (p){
    case gv : return "GV";
    case deck : return "Deck";
    case hand : return "Hand";
    case ban : return "Outer Space";
    };
    throw "Error in mul_place_type_2_string";
  };

  // }}}
  // {{{ int get_loc(int i) const throw std::invalid_argument

  /**
   * @brief A helper function that turns the user-friendly index i, into the
   * program friendly index loc.
   * @param i the index input by the user.
   *
   * Returns a location on the deck from 0 to size(). Return size() means we
   * need to add a card.
   */
  int get_loc(int i) const{
    int loc;
    if (i < 0){
      // Get from the bottom (-1 means 0, -2 means 1)
      loc = -i + 1;
    }else{
      // Count from back. E.g. (0) means push_back. (1) means size()-1
      loc = size() - i;
    }

    cout << S_GREEN "**get_loc : i is " << i << ", loc is " << loc << "**\n" S_NOR;

    if ( loc < 0 || loc > size()){
      throw invalid_argument("i int get_loc() in mul_place");
    }
    return loc;
 }

  // }}}
};

// {{{void test_mul_place();

void test_mul_place(){
  report("mul_place");
  player p("Yuya");
  mul_place mp(mul_place::mul_place_type::gv, &p);
  cout << "Place 1:\n" << mp << endl;

  report("Place card in mul_place");
  card c1("Blue Eyes"), c2("Kulibal"), c3("水罩");

  mp.add_card(&c1, 0);
  mp.add_card(&c2, 0);
  mp.add_card(&c3, 0);

  cout << "After placing cards, the deck is\n" << mp ;

  report("Drop cards from mul_place");
  for (int i = 0;! mp.is_empty(); i++){
    cout << "Drop " << i+1 << " times\n" ;
    cout << "Card droped" << *(mp.drop_card()) << endl;
    cout << "Now the deck is: \n" << mp << "\n\n";
  }
}

// }}}

// }}}
// {{{ class sig_place

// {{{ class card_already_exits : public std::exception


class card_already_exits : public std::exception{
public:
  string s;
  string s2;
  explicit card_already_exits(string _s, string _s2): s(_s), s2(_s2){};
  const string what(){
    return
      string("Trying to place card [") + s2 + "] on [" + s +  "]";
      }
};

// }}}
class sig_place : public place {
public:
  enum sig_place_type {mt, ms, p};
  card* c = NULL;
  sig_place(sig_place_type t = mt, player *p = NULL): type(t),
                                          place(p, sig_place_type_2_string(t)){};
  // {{{ void place_card(card *c_)

  void place_card(card *c_){
#ifdef VERBOSE
    cout << "Trying to place card: " << c_->name << endl;
#endif
    if (!is_empty()){
      throw card_already_exits(c->name, c_->name);
    }else{
      c = c_;
    }
  };

  // }}}
  // {{{ card* remove_card()

  card* remove_card(){
    card* tmp = c;
    c = NULL;
    return tmp;
  }

  // }}}
  // {{{bool is_empty() const

  bool is_empty() const {
    return (c ? false : true);
  }

  // }}}
  // {{{ operator<<

  friend ostream& operator<<(ostream& os, const sig_place &p){
    os << "["
       << (p.c ? p.c->name : "---")
       << "]  "
       << dynamic_cast<const place&>(p);
    return os;
  };

  // }}}

private:
  sig_place_type type;
  // {{{ string sig_place_type_2_string(sig_place_type p)

  string sig_place_type_2_string(sig_place_type t){
    switch (t){
    case mt : return "magic/trap zone";
    case ms : return "monster zone";
    case p : return "pendulum zone";
    };
    throw "Error in sig_place_type_2_string";
  };

  // }}}
};

void test_sig_place(){
  report("sig_place");
  player p("Yuya");
  sig_place p1(sig_place::sig_place_type::mt, &p);
  cout << "Before placing card: \n"
       << "Place 1: " << p1 << endl
       << "After placing card: \n";

  card c("Kulibal");
  p1.place_card(&c);
  cout << "Place 1: " << p1 << endl;

  card c2("Blue");
  try {
    p1.place_card(&c2);
  }catch(card_already_exits& e){
    cout << "Error caught 🐸:\n"
         << e.what() << endl;
  }
  cout << "Remove the card and try place again\n";
  p1.remove_card();
  cout << "After removing the card, the place is " << p1 << endl;

  cout << "Now try to place the card again\n";
  try {
    p1.place_card(&c2);
  }catch(card_already_exits& e){
    cout << "Error caught 🐸:\n"
         << e.what() << endl;
  }
  cout << "Now the place : " << p1 << endl;

}

// }}}

// {{{ struct dual_disk

#define NUMBER_OF_ZONES 3
struct dual_disk{
  player *owner = NULL;

  // {{{ The cards

  sig_place *mt_zones[NUMBER_OF_ZONES]; // array of pointers to single zones.
  sig_place *ms_zones[NUMBER_OF_ZONES];

  mul_place *gv;
  mul_place *ban;
  mul_place *deck;
  mul_place *hand;

  // }}}
  // {{{ CONSTRUCTOR(player *p)

  dual_disk(player *p): owner(p){
    cout << "Dual Disk set for " << p->name << endl;
    // Init the pointers here
    for (int i = 0; i < NUMBER_OF_ZONES; i++){
      mt_zones[i] = new sig_place(sig_place::sig_place_type::mt, p);
      ms_zones[i] = new sig_place(sig_place::sig_place_type::ms, p);
    }

    gv = new mul_place(mul_place::mul_place_type::gv, p);
    deck = new mul_place(mul_place::mul_place_type::deck,p);
    hand = new mul_place(mul_place::mul_place_type::hand,p);
    ban = new mul_place(mul_place::mul_place_type::ban,p);
  };

  // }}}
  // {{{ DESTRUCTOR

  ~dual_disk(){
    cout << "Dual Disk freed for " << owner->name << endl;

    for (int i = 0; i < NUMBER_OF_ZONES; i++){
      delete mt_zones[i];
      delete ms_zones[i];
    }

    delete gv;
    delete deck;
    delete hand;
    delete ban;
  };

  // }}}
};

void test_dual_disk(){
  report("dual_disk");
  {
    player p("Yuya");
    dual_disk d(&p);
  }
}

// }}}


// {{{ main()
#ifdef TEST
int main(int argc, char *argv[]){
  // test_mst_card();
  // test_player();
  // test_place();
  test_mul_place();
  // test_sig_place();
  return 0;
  }
#endif
// }}}

