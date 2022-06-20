#include "mylib2.h"

namespace mylib2{
  string Sprintf(const char* fmt,...){
    char my_sprintf_buffer[80];                // sprintf buffer
    va_list args;
    va_start (args,fmt);
    vsprintf (my_sprintf_buffer,fmt,args);
    va_end (args);
    return string(my_sprintf_buffer);
  }

  void Rule(string title, int sublevel, int len){
    title = string(sublevel * 2,' ') + title;
    len -= title.length();
    cout << S_BLUE << title << string(len, '-') << endl << S_NOR;
  }

  string Strftime(string fmt){
    time_t curr_time;
    tm * curr_tm;
    char date_string[100];
    time(&curr_time);
    curr_tm = localtime(&curr_time);
    strftime(date_string, 50, fmt.c_str(), curr_tm);
    return string(date_string);
  }

  namespace math{

    tuple<double,double> SolveQuadratic(double a,
                          double b,
                          double c){
      double th = b*b - 4*a*c;
      printf("SolveQuadratic called with \n\ta =%10.4g, b =%10.4g\n\tc =%10.4g, th=%10.4g\n",
             a,b,c,th);
      if (th < 0){
        // printf("Yep th < 0\n");
        string m = Sprintf("b^2 - 4ac = %d < 0",th);
        // printf("Message: %s\n", m.c_str());
        throw domain_error(m);
      }else{
        double x = - b / (2*a);
        double y = sqrt(th) / (2*a);
        // Use " " to refer to the global namespace.
        return ::std::make_tuple(x+y, x-y);
      }
    }

    void test_SolveQuadratic(my_test::tester &tr){
      double r1,r2;
      std::tie(r1,r2) = SolveQuadratic(1,0,-1);
      tr.expect_near(r1,1, "Root 1, Eqn 1");
      tr.expect_near(r2,-1, "Root 2, Eqn 1");

      std::tie(r1,r2) = SolveQuadratic(1,0,0);
      tr.expect_near(r1,0, "Root 1, Eqn 2");
      tr.expect_near(r2,0, "Root 2, Eqn 2");
      auto f = [](void){SolveQuadratic(1,0,1);};

      // Works
      // try{
      //   f();
      // }catch (domain_error &e){
      //   cout << "Error caught: " << e.what() << endl;
                                // }

      tr.expect_error<domain_error>([](void){SolveQuadratic(1,0,1);},
                                    "A quadratic without roots");
    }
  }
}
