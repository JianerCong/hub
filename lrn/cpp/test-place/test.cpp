#include <iostream>
#include <rocksdb/db.h>

using std::cout;
using std::string;

int main(){
  rocksdb::DB* db;
  rocksdb::Options options;
  options.create_if_missing = true;
  rocksdb::Status status = rocksdb::DB::Open(options, "/tmp/testdb", &db);
  assert(status.ok());
  cout << status.ToString();

  delete db;
}
