
#include <boost/log/attributes/scoped_attribute.hpp> // BOOST_LOG_SCOPED_THREAD_TAG(...);
#include <boost/log/attributes/value_extraction.hpp>
#include <boost/log/core.hpp>
#include <boost/log/expressions.hpp>
#include <boost/log/sinks/sync_frontend.hpp>
#include <boost/log/sinks/text_ostream_backend.hpp>
#include <boost/log/sources/record_ostream.hpp>
#include <boost/log/sources/severity_logger.hpp>
#include <boost/log/trivial.hpp>
#include <boost/log/utility/formatting_ostream.hpp>
#include <boost/log/utility/setup/common_attributes.hpp>
#include <boost/optional.hpp>
#include <boost/smart_ptr/make_shared_object.hpp>
#include <boost/smart_ptr/shared_ptr.hpp>
#include <fstream>
#include <ostream>

namespace logging = boost::log;
namespace src = boost::log::sources;
namespace expr = boost::log::expressions;
namespace sinks = boost::log::sinks;
namespace attrs = boost::log::attributes;
namespace keywords = boost::log::keywords;

BOOST_LOG_ATTRIBUTE_KEYWORD(tag_attr, "Tag", std::string)
void init(){
    // Setup the common formatter for all sinks
    logging::formatter fmt = expr::stream
        << expr::if_(expr::has_attr(tag_attr)) [expr::stream << "[" << tag_attr << "] "]
        << expr::smessage;

    // Initialize sinks
    typedef sinks::synchronous_sink< sinks::text_ostream_backend > text_sink;
    boost::shared_ptr< text_sink > sink = boost::make_shared< text_sink >();

    // sink 1 has no filter
    sink->locked_backend()->add_stream(boost::make_shared< std::ofstream >("hi.log"));
    sink->set_formatter(fmt);
    logging::core::get()->add_sink(sink);

    // sink 2 has a filter and will only log records with tag_attr == "AAA"
    sink = boost::make_shared<text_sink>();
    sink->locked_backend()->add_stream(boost::make_shared< std::ofstream >("hi2.log"));
    sink->set_formatter(fmt);
    sink->set_filter(expr::has_attr(tag_attr) && tag_attr == "AAA");
    logging::core::get()->add_sink(sink);

    // Add attributes
    logging::add_common_attributes();
}
int main(int, char*[]){
  init();

  src::severity_logger<logging::trivial::severity_level> slg;
  BOOST_LOG_SEV(slg, logging::trivial::severity_level::trace) << "aaa";

  {
    BOOST_LOG_SCOPED_THREAD_TAG("Tag", "AAA");
    BOOST_LOG_SEV(slg, logging::trivial::severity_level::trace) << "aaa with AAA";
  }

  src::severity_logger<logging::trivial::severity_level> slg2;
  // Add an attribute to this log
  slg2.add_attribute("Tag", attrs::constant<std::string>("AAA"));
  BOOST_LOG_SEV(slg2, logging::trivial::severity_level::trace) << "bbb with AAA";
  return 0;
}
