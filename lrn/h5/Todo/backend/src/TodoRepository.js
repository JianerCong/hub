const Todo = require('./Todo');

class TodoRepository {
  constructor(model) {
    this.model = model;
  }

  create(name, done = false, unam = '', ddl = '') {
    const newTodo = { name, done, unam ,ddl};
    // eslint-disable-next-line new-cap
    const todo = new this.model(newTodo);

    return todo.save();
  }

  findAll(unam = '') {
    if (unam === '') {
      return this.model.find();
    }
    return this.model.find({ unam });
  }

  deleteAll(unam = '') {
    if (unam === '') {
      return this.model.deleteMany({});
    }
    return this.model.deleteMany({ unam });
  }

}

module.exports = new TodoRepository(Todo);
