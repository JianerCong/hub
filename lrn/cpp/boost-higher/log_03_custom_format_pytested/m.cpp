#include <fstream>
#include <iomanip>
#include <boost/smart_ptr/shared_ptr.hpp>
#include <boost/smart_ptr/make_shared_object.hpp>
#include <boost/log/core.hpp>
#include <boost/log/trivial.hpp>
#include <boost/log/expressions.hpp>
#include <boost/log/sinks/sync_frontend.hpp>
#include <boost/log/sinks/text_ostream_backend.hpp>
#include <boost/log/sources/severity_logger.hpp>
#include <boost/log/sources/record_ostream.hpp>
#include <boost/log/utility/setup/common_attributes.hpp>

namespace logging = boost::log;
namespace src = boost::log::sources;
namespace expr = boost::log::expressions;
namespace sinks = boost::log::sinks;
namespace keywords = boost::log::keywords;

void init(){
  typedef sinks::synchronous_sink< sinks::text_ostream_backend > text_sink;
  boost::shared_ptr< text_sink > sink = boost::make_shared< text_sink >();

  sink->locked_backend()->add_stream(boost::make_shared< std::ofstream >("hi.log"));
  sink->set_formatter
    (expr::stream
     // line id will be written in hex, 8-digits, zero-filled
     << expr::attr< unsigned int >("LineID")
     << ": <" << logging::trivial::severity
     << "> " << expr::smessage
     );

  logging::core::get()->add_sink(sink);
}

int main(int, char*[]){
  init();
  logging::add_common_attributes();

  using namespace logging::trivial;
  src::severity_logger< severity_level > lg;

  BOOST_LOG_SEV(lg, trace) << "aaa";
  BOOST_LOG_SEV(lg, debug) << "bbb";

  return 0;
}
