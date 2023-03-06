// #define BOOST_TEST_MAIN
#define BOOST_TEST_MODULE MyTest
#include <boost/test/unit_test.hpp>
#include <stdexcept>


BOOST_AUTO_TEST_CASE(test_1) {
  BOOST_CHECK_NE(2,1);          // 2 != 1
} // BOOST_AUTO_TEST_CASE(test_no_1)

void f(){
  throw std::runtime_error("hi");
}

BOOST_AUTO_TEST_CASE(test_2) {
  BOOST_CHECK_THROW(f(), std::runtime_error);
}


BOOST_AUTO_TEST_CASE(test_equal) {
  BOOST_CHECK_EQUAL(1, 1);
}

BOOST_AUTO_TEST_CASE(test_error) {
  BOOST_ERROR("this should give error ❄");
}


BOOST_AUTO_TEST_CASE(test_fail) {
  BOOST_FAIL("this should give fatal error ❄");
}
