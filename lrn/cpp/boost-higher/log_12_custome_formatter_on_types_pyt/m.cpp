#include <boost/core/null_deleter.hpp>
#include <boost/log/attributes/scoped_attribute.hpp> // BOOST_LOG_SCOPED_THREAD_TAG(...);
#include <boost/log/attributes/value_extraction.hpp>
#include <boost/log/core.hpp>
#include <boost/log/expressions.hpp>
#include <boost/log/sinks/sync_frontend.hpp>
#include <boost/log/sinks/text_ostream_backend.hpp>
#include <boost/log/sources/logger.hpp>
#include <boost/log/sources/record_ostream.hpp>
#include <boost/log/sources/severity_logger.hpp>
#include <boost/log/utility/formatting_ostream.hpp>
#include <boost/log/utility/formatting_ostream.hpp>
#include <boost/log/utility/manipulators/to_log.hpp>
#include <boost/log/utility/setup/common_attributes.hpp>
#include <boost/log/utility/setup/console.hpp>
// #include <boost/optional.hpp>
// #include <boost/smart_ptr/make_shared_object.hpp>
#include <boost/smart_ptr/shared_ptr.hpp>
#include <fstream>
#include <ostream>

#include <string>
#include <cctype>               // toupper
using std::string;

namespace logging = boost::log;
namespace src = boost::log::sources;
namespace expr = boost::log::expressions;
namespace sinks = boost::log::sinks;
namespace attrs = boost::log::attributes;
namespace keywords = boost::log::keywords;

struct A_tag;                   // just a template switcher
// The above type makes it switch to the following operator
logging::formatting_ostream& operator<<(
                                        logging::formatting_ostream& strm,
                                        logging::to_log_manip< string, A_tag > const& m
                                        ){
  string s = m.get();
  // To upper
  std::transform(s.cbegin(), s.cend(),
                 s.begin(), // write to the same location
                 [](unsigned char c) { return std::toupper(c); });
  strm << s;
  return strm;
}

BOOST_LOG_ATTRIBUTE_KEYWORD(tag_attr, "My Tag", std::string);
void init(){
  logging::add_console_log(
                           std::clog,
                           keywords::format =
                           (
                            expr::stream
                            << expr::attr< unsigned int >("LineID")
                            << ": <" << expr::attr< string , A_tag >("My Tag")
                            << "> " << expr::smessage
                            )
                           );
  logging::add_common_attributes(); // add LineID
}

#include <boost/log/utility/manipulators/add_value.hpp> // logging::add_value
int main(int, char*[]){
  init();
  src::logger lg;
  BOOST_LOG(lg) << "aaa";
  // This record has "Tag" attribute
  BOOST_LOG(lg) << logging::add_value("My Tag","abc") << "aaa";
  return 0;
}
