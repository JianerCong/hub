/*
  add
*/
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
#include <boost/log/utility/manipulators/to_log.hpp>
#include <boost/log/utility/setup/common_attributes.hpp> // add_common_attributes: "LineID" "TimeStamp" "ProcessID" "ThreadID"
#include <boost/log/utility/setup/console.hpp> // add_console_log
#include <boost/log/utility/setup/file.hpp> // add_file_log

// #include <boost/optional.hpp>
// #include <boost/smart_ptr/make_shared_object.hpp>
#include <boost/smart_ptr/shared_ptr.hpp>
#include <fstream>
#include <ostream>
#include <iostream>
#include <boost/log/utility/manipulators/add_value.hpp> // logging::add_value

#include <string>
#include <cctype>               // toupper
using std::string;


BOOST_LOG_ATTRIBUTE_KEYWORD(tag_attr, "Tag", std::string);
void init(){
  namespace logging = boost::log;
  namespace src = boost::log::sources;
  namespace expr = boost::log::expressions;
  namespace sinks = boost::log::sinks;
  namespace attrs = boost::log::attributes;
  namespace keywords = boost::log::keywords;
  /*
    🦜 : Set up filter such that, if "My Tag" is present, write to file
  */
  logging::add_console_log(std::cout, // 🦜 : works?: 🐢: Yeah
                           keywords::format = (expr::stream << tag_attr << expr::smessage),
                           keywords::filter = (not expr::has_attr("Tag"))
                           // ❌️ ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ not working well...
                           // `tag_attr` is not simply `expr::attr<string>("Tag")` ?
                           );

  logging::add_file_log(keywords::file_name = "hi_%N.log",                                        /*< file name pattern >*/
                        keywords::rotation_size = 10 * 1024 * 1024,                                   /*< rotate files every 10 MiB... >*/
                        // // keywords::time_based_rotation = sinks::file::rotation_at_time_point(0, 0, 0), /*< ...or at midnight >*/
                        // keywords::filter = (expr::has_attr(tag_attr)),
                        keywords::format = (expr::stream << expr::smessage)
                        );

  logging::add_common_attributes();
}

int main(int, char*[]){
  init();
  boost::log::sources::logger lg;

  BOOST_LOG(lg) << "aaa";

  // This record has "Tag" attribute
  BOOST_LOG(lg) << boost::log::add_value("Tag","abc") << "bbb";

  return 0;
}
