/* eslint-disable no-console */
const createError = require('http-errors'); // Create http errors
const express = require('express');

const mongoose = require('mongoose');
const logger = require('morgan'); // http request logger
const cors = require('cors');

const routes = require('./src/Routes');
const config = require('./src/Config');

const app = express();


// For naming your mongodb database, you should place it in your connection
// string, like: mongoose.connect('mongodb://localhost/myDatabaseName');

mongoose.connect(config.DB, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// const cookieParser = require('cookie-parser');
// app.use(cookieParser());

// Parse Cookies make it a fields in req.cookies as in curl
// http://127.0.0.1:8080 --cookie "Cho=Kim;Greet=Hello"

app.use(cors());
 // enable cors: Cross Origin Request. Simply use it. No why

app.use(logger('dev'));
app.use(express.json()); // parse json t
app.use(express.urlencoded({ extended: false })); // parse urlencoded request

// app.use(express.static(path.join(__dirname, 'public'))); //serve public files
app.get('/hi', (req, res) => {
  res.send('hi from todo-backend server');
});

app.use('/todos', routes); // all reqs should be handled in this

// catch 404 and forward to error handler
app.use((req, res, next) => {
  next(createError(404));
});

// error handler
app.use((err, req, res) => {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

const server = app.listen(config.APP_PORT, () => {
  const FuncPort = server.address().port;
  const host = server.address().address;
  console.log('Example app listening at http://%s:%s', host, FuncPort);
}); // Listen on port defined in environment

mongoose.connection.on('connected', () => {
  console.log('connected to mongodb 🐸');
});

mongoose.connection.on('error', () => {
  console.log('error connecting to mongodb 😭');
});

module.exports = app;
