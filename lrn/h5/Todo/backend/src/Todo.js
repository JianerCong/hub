const mongoose = require('mongoose');

const { Schema } = mongoose;

// Define schema for todo items
const todoSchema = new Schema(
  {
    name: {
      type: String,
    },
    done: {
      type: Boolean,
    },
    unam: {
      type: String,
    },
    ddl: {
      type: String,
    },
  },
  { collection: 'todoItems' }, // the collection name
);

module.exports = mongoose.model('Todo', todoSchema);
