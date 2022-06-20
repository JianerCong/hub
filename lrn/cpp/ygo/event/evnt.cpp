/**
 * @file event.cpp
 * @author Jianer Cong
 * @brief define the evnt class
 * 
 * The differences between this file and
 * the evnt.cpp.old is that this file
 * defines a += instead of + and =
 * seperately.
 */

#include <iostream>
#include <vector>
#include <cstring>


namespace mygo{

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

  using std::cout;
  using std::vector;
  using std::endl;
  using std::cin;
  using std::string;

  template<typename T=int>
  class evnt {
  public:
    evnt(T default_msg, string nam="BASE-🐸-EVNT");
    virtual ~evnt();
    void operator()(T msg);
    evnt<T>& operator+=(void(*f)(T));
  private:
    T _default_msg;
    string _nam;
    typedef void (*responser)(T);
    vector<responser> listeners;
  };

  template<typename T>
  evnt<T>::evnt(T default_msg, string nam):
    _default_msg(default_msg), _nam(nam)
  {
   cout << "Evnt " << nam << "created.\n";
   // Add a default verbose listeners
   // this->listeners.push_back(...);
  }

  template<typename T>
  void evnt<T>::operator()(T msg){
    cout << "Who are listeners?: \n";
    for (responser f : this->listeners){
      cout << "Me🐸..\t:";
      f(msg);
    }
    cout << "Done\n";
  }

  template<typename T>
  evnt<T>& evnt<T>::operator+=(void(*f)(T)){
    cout << "Adding listener\n";
    this->listeners.push_back(f);
    return *this;
  }

  template<typename T>
  evnt<T>::~evnt(){
    cout << "Evnt " << this->_nam<< " is gone.💧\n";
  }

}


using std::cout;
using std::endl;
using std::string;


inline void report(const char* s);
void test_evnt(void){
  report("evnt");
  mygo::evnt<int> e(1,"❄My-Event❄");
  e  += [](int x){cout << "🐸 Listener 1 heard : " << x << endl;};
  e += [](int x){cout << "🐸 Listener 2 heard : " << x << endl;};
  cout << "Try triggering the evnt with 2:\n";
  e(2);
}

inline void report(const char* s){
  cout << "Testing " << s << " "<< string( 50 - strlen(s), '-') << endl;
}

#ifdef TEST
int main(int argc, char *argv[]){
  test_evnt();
  return 0;
}
#endif
