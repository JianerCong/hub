using System;

namespace Testing
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
        }
    }

    class TestFailed

    class Tester{
        bool verbose;
        public Tester(bool v) => verbose = v;
        public void Log(string s){
            if (verbose)
                Console.WriteLine(s);
        }
        public void Fatal(string msg){
            throw TestFailed(msg);
        }
    }
}
