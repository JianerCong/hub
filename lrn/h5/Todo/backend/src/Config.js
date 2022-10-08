const TEST_MODE = process.argv.includes('test');
let testDb;
if (TEST_MODE) {
    console.log('Running in test mode');
    testDb = 'mongodb://localhost:27017/test';
}else{
    console.log('Running in nontest mode');
}
const url = process.env.MONGO_HOST ? `mongodb://${process.env.MONGO_HOST}:27017/todos` : undefined;
const DB = url || testDb ||'mongodb://localhost:27017/todos';

console.log(`db is ${DB}`);

module.exports = {
  DB,
  // 'todos' becomes the db name
  APP_PORT: process.env.APP_PORT || 9001,
};
