/*
 *          Copyright Andrey Semashev 2007 - 2015.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */


#include <boost/date_time/posix_time/posix_time.hpp>
#include <boost/log/attributes.hpp>
#include <boost/log/attributes/scoped_attribute.hpp>
#include <boost/log/core.hpp>
#include <boost/log/expressions.hpp>
#include <boost/log/sinks/sync_frontend.hpp>
#include <boost/log/sinks/text_ostream_backend.hpp>
#include <boost/log/sources/basic_logger.hpp>
#include <boost/log/sources/record_ostream.hpp>
#include <boost/log/sources/severity_logger.hpp>
#include <boost/log/utility/setup/common_attributes.hpp>

#include <boost/log/trivial.hpp> // 🐢 Include this
#include <boost/smart_ptr/make_shared_object.hpp>
#include <boost/smart_ptr/shared_ptr.hpp>
#include <cstddef>
#include <fstream>
// #include <iomanip>
#include <ostream>
#include <string>

namespace logging = boost::log;
namespace src = boost::log::sources;
namespace expr = boost::log::expressions;
namespace sinks = boost::log::sinks;
namespace attrs = boost::log::attributes;
namespace keywords = boost::log::keywords;


#include <chrono>
#include <thread>
void logging_function(){
  using namespace std::chrono_literals;
  src::severity_logger<logging::trivial::severity_level> slg;
  BOOST_LOG_SEV(slg, logging::trivial::severity_level::trace) << "aaa";
  std::this_thread::sleep_for(2000ms);
  BOOST_LOG_SEV(slg, logging::trivial::severity_level::trace) << "bbb";
}

BOOST_LOG_ATTRIBUTE_KEYWORD(timeline, "Timeline", attrs::timer::value_type)
//[ example_tutorial_attributes_timed_logging
void timed_logging(){
  BOOST_LOG_SCOPED_THREAD_ATTR("Timeline", attrs::timer());

  src::severity_logger<logging::trivial::severity_level> slg;
  BOOST_LOG_SEV(slg, logging::trivial::severity_level::trace) << "timmer started";
  logging_function();
  BOOST_LOG_SEV(slg, logging::trivial::severity_level::trace) << "timmer ended";
}
//]


void init(){
  typedef sinks::synchronous_sink< sinks::text_ostream_backend > text_sink;
  boost::shared_ptr< text_sink > sink = boost::make_shared< text_sink >();

  sink->locked_backend()->add_stream(boost::make_shared< std::ofstream >("hi.log"));
  sink->set_formatter(// 🦜 : These magical "vars" are defined in BOOST_LOG_ATTRIBUTE_KEYWORD(...)
                      expr::stream
                      << expr::if_(expr::has_attr(timeline))
                      [expr::stream << "[" << timeline << "] "]
                      << expr::smessage
                      );

  logging::core::get()->add_sink(sink);

  // Add attributes
  logging::add_common_attributes();
  logging::core::get()->add_global_attribute("Scope", attrs::named_scope());
}

int main(int, char*[]){
  init();
  timed_logging();

  src::severity_logger<logging::trivial::severity_level> slg;
  BOOST_LOG_SEV(slg, logging::trivial::severity_level::trace) << "aaa untimed";
  return 0;
}
