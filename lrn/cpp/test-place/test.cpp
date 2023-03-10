#include <boost/log/common.hpp>
#include <boost/log/sinks.hpp>
#include <boost/log/sources/logger.hpp>
// #include <boost/utility/empty_deleter.hpp>
#include <boost/shared_ptr.hpp>
#include <iostream>

using namespace boost::log;
int main(){
  typedef sinks::asynchronous_sink<sinks::text_ostream_backend>
    text_sink;
  boost::shared_ptr<text_sink> sink =
    boost::make_shared<text_sink>();

  boost::shared_ptr<std::ostream> stream {
    &std::clog                 // standard output stream for logging
    ,boost::null_deleter()
    // ,boost::empty_deleter
  };

  // access the backend through locked_backend()
  sink->locked_backend()->add_stream(stream);

  core::get()->add_sink(sink);
  // default log connects it self to core.
  sources::logger lg;
  BOOST_LOG(lg) << "aaa";

  sink->flush();
}
