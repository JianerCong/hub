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
#include <iomanip>
#include <ostream>
#include <string>

namespace logging = boost::log;
namespace src = boost::log::sources;
namespace expr = boost::log::expressions;
namespace sinks = boost::log::sinks;
namespace attrs = boost::log::attributes;
namespace keywords = boost::log::keywords;


BOOST_LOG_ATTRIBUTE_KEYWORD(scope, "Scope", attrs::named_scope::value_type)

void named_scope_logging(){
  BOOST_LOG_NAMED_SCOPE("s1");


  src::severity_logger<logging::trivial::severity_level> slg;
  BOOST_LOG_SEV(slg, logging::trivial::severity_level::trace) << "scoped-aaa";
}



void init(){
  typedef sinks::synchronous_sink< sinks::text_ostream_backend > text_sink;
  boost::shared_ptr< text_sink > sink = boost::make_shared< text_sink >();

  sink->locked_backend()->add_stream(boost::make_shared< std::ofstream >("hi.log"));
  sink->set_formatter(// 🦜 : These magical "vars" are defined in BOOST_LOG_ATTRIBUTE_KEYWORD(...)
                      expr::stream
                      << "(" << scope << ") "
                      << expr::smessage);

  logging::core::get()->add_sink(sink);

  // Add attributes
  logging::add_common_attributes();
  logging::core::get()->add_global_attribute("Scope", attrs::named_scope());
}

int main(int, char*[]){
  init();
  named_scope_logging();

  src::severity_logger<logging::trivial::severity_level> slg;
  BOOST_LOG_SEV(slg, logging::trivial::severity_level::trace) << "aaa";
  return 0;
}
