namespace Testing{
    using System;
    using System.Collections.Generic;
    public class TestFailedException: Exception {
        public TestFailedException(string msg) : base(msg){}
    }

    public class Test{
        const string S_RED    ="\x1b[31m";
        const string S_GREEN  ="\x1b[32m";
        const string S_NOR    ="\x1b[0m";
        public class Row{
            public readonly ToBeTest func;
            public readonly string name;
            public string msg = " ";
            public Row(ToBeTest f, string n) => (func, name) = (f,n);
        }
        List<Row> fs = new List<Row>();
        Tester examer;
        // the functions to be tested

        public Test(bool v) => examer= new Tester(v);
        public void Add(ToBeTest f, string name){
            fs.Add(new Row(f,name));
        }

        public void Run(){
            // Run and get results
            for (int i=0;i < fs.Count;i++){
                testThat(i);
            }
            examer.Rule("Test Finished");
        }

        public void ShowTests(){
            Console.WriteLine("The following tests will be run:");
            for (int i=0;i<fs.Count; i++){
                Console.WriteLine("     " + fs[i].name);
            }
        }

        public void ShowResults(){
            Console.WriteLine("Test Results:");
            for (int i=0;i<fs.Count; i++){
                Console.WriteLine("{0,10} : {1}",fs[i].name,fs[i].msg);
            }
        }

        void testThat(int i){
            examer.Rule(string.Format("Testing {0}", fs[i].name));
            try{
                fs[i].func(ref examer);
                fs[i].msg = S_GREEN + "OK" + S_NOR;
            }catch (TestFailedException e){
                fs[i].msg =string.Format("{1}: {0}",e.Message, S_RED + "NOPE" + S_NOR);
            } catch (Exception e1){
                fs[i].msg =string.Format("{1}: {0}",e1.Message, S_RED + "UNEXPECTED" + S_NOR);
            }
        }

    }

    public delegate void ToBeTest (ref Tester t);

    public class Tester{
        bool verbose;
        const string prefix = "";
        public Tester(bool v) => verbose = v;

        public void Rule(string s = "") => Log("\n" + s
                                               + " "
                                               + new string('=',50 - s.Length));
        public void Log(string s){
            if (verbose){
                Console.WriteLine(prefix + s);
            }
        }

        public void ExpectEqual<T>(IEquatable<T> x, IEquatable<T> y){
            string msg = $"Should be {x}, it is {y}";
            Log(msg);
            if (!x.Equals(y)){
                throw new TestFailedException(msg);
            }
        }

        public void Fatal(string s){
            throw new TestFailedException(s);
        }
    }
}
