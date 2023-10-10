#include <boost/move/utility_core.hpp>
#include <boost/log/sources/logger.hpp>
#include <boost/log/sources/record_ostream.hpp>
#include <boost/log/sources/global_logger_storage.hpp>
#include <boost/log/utility/setup/file.hpp>
#include <boost/log/utility/setup/common_attributes.hpp>

namespace logging = boost::log;
namespace src = boost::log::sources;
namespace keywords = boost::log::keywords;

BOOST_LOG_INLINE_GLOBAL_LOGGER_DEFAULT(my_logger, src::logger_mt)

void logging_function1()
{
  src::logger lg;

  //[ example_tutorial_logging_manual_logging
  logging::record rec = lg.open_record();
  if (rec)
    {
      logging::record_ostream strm(rec);
      strm << "aaa local";
      strm.flush();
      lg.push_record(boost::move(rec));
    }
  //]
}

void logging_function2()
{
  src::logger_mt& lg = my_logger::get();
  BOOST_LOG(lg) << "aaa global";
}

int main(int, char*[])
{
  logging::add_file_log("hi.log");
  logging::add_common_attributes();

  logging_function1();
  logging_function2();

  return 0;
}
