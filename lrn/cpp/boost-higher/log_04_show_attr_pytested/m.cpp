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


BOOST_LOG_ATTRIBUTE_KEYWORD(tag_attr, "Tag", std::string)
// ^^^ 🦜: this does sth like
//            #define tag_attr expr::attr<std::string>("Tag")

void tagged_logging(){

  // Get the trivial logger (automatically connected to core)
  src::severity_logger<logging::trivial::severity_level> slg;
  //                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ A enum

  // Add an attribute to this log
  slg.add_attribute("Tag", attrs::constant<std::string>("My tag value"));

  BOOST_LOG_SEV(slg, logging::trivial::severity_level::trace) << "tagged-aaa";
}

void init(){
  typedef sinks::synchronous_sink< sinks::text_ostream_backend > text_sink;
  boost::shared_ptr< text_sink > sink = boost::make_shared< text_sink >();

  sink->locked_backend()->add_stream(
                                     boost::make_shared< std::ofstream >("hi.log"));

  sink->set_formatter(
                      // 🦜 : These magical "vars" are defined in BOOST_LOG_ATTRIBUTE_KEYWORD(...)
                      expr::stream
                      // 🦜 : Print the tag if exists
                      << expr::if_(expr::has_attr(tag_attr))[expr::stream << "[" << tag_attr << "] "]
                      << expr::smessage);

  logging::core::get()->add_sink(sink);
  // Add attributes
  logging::add_common_attributes();
}

int main(int, char*[])
{
  init();
  tagged_logging();

  // Get the trivial logger (automatically connected to core)
  src::severity_logger<logging::trivial::severity_level> slg;
  BOOST_LOG_SEV(slg, logging::trivial::severity_level::trace) << "untagged-aaa";
  return 0;
}
