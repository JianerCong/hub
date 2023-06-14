/*
 *          Copyright Andrey Semashev 2007 - 2015.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */

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

void f(logging::record_view const& rec, logging::formatting_ostream& strm){
  // Get the LineID attribute value and put it into the stream
  strm << logging::extract< unsigned int >("LineID", rec) << ": ";

  // The same for the severity level. The simplified syntax is possible if
  // attribute keywords are used.
  strm << "<" << rec[logging::trivial::severity] << "> ";

  // Finally, put the record message to the stream
  strm << rec[expr::smessage];
}


void init(){
  typedef sinks::synchronous_sink< sinks::text_ostream_backend > text_sink;
  boost::shared_ptr< text_sink > sink = boost::make_shared< text_sink >();

  sink->locked_backend()->add_stream(
                                     boost::make_shared< std::ofstream >("hi.log"));

  sink->set_formatter(&f);

  logging::core::get()->add_sink(sink);
  logging::add_common_attributes();
}

int main(int, char*[]){
  init();

  src::severity_logger<logging::trivial::severity_level> slg;
  BOOST_LOG_SEV(slg, logging::trivial::severity_level::trace) << "aaa";
  BOOST_LOG_SEV(slg, logging::trivial::severity_level::debug) << "bbb";
  return 0;
}
