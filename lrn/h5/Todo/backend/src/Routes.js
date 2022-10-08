/* eslint-disable no-console */
const express = require('express');
const repository = require('./TodoRepository');

const routes = express.Router();
const handleError = require('./handleError.js');

function getUnam(req) {
  const unam = req.body.unam || '';
  if (unam !== '') {
    console.log(`👉 ${unam}`);
  } else {
    console.log('🙌');        // not serving anyone
  }
  return unam;
}

function handleGetAll(req, res) {
  const unam = getUnam(req);

  repository.findAll(unam).then((todos) => {
    res.json(todos);
  }).catch(handleError);
}

routes.get('/hi', (req,res) => {
  res.send('hi from todo-backend /todos');
});

// get all todo items in the db
routes.get('/', handleGetAll);  // use this to get all todos from all users
routes.post('/getall', handleGetAll); // use this when you need to get from some user



async function postOne(todo, unam, res){
  const {name, done , ddl} = todo;

  await repository.create(name, done || false, unam, ddl || '' ).then((todo) => {
    res.json(todo);
  }).catch(handleError);
}

// add a todo item
// example of req: {'name': 'do sth','done': False, 'unam': 'aaa'}
routes.post('/', async (req, res) => {
  const { name , done } = req.body;
  const unam = getUnam(req);
  await postOne(req.body, unam, res);
});

// add an array of todo item
// example of req.body {'unam': 'aaa',
// 'todos': [{name: 'c1', done: False}, {name: 'c2', done:False}]}
routes.post('/postmany', async (req, res) => {
  const unam = getUnam(req);
  const {todos} = req.body;

  let outTodos = [];
  // console.log(`Body: ${JSON.stringify(req.body)}`);
  console.log(`🌳Posting ${todos.length} todos`);
  for (todo of todos){
    // same as adding one todos
    const { name , done, ddl } = todo;

    await repository.create(name, done || false, unam, ddl || '').then((todo) => {
      outTodos.push(todo);
    }).catch(handleError);
}
  res.json(outTodos);
});


// delete all
routes.delete('/', (req, res) => {
  const unam = getUnam(req);

  repository.deleteAll(unam).then((out) => {
    console.log(`🪵deleted ${out.deletedCount} todo entries`);
    res.status(200).json([]);
  }).catch(handleError);
});

// update a todo item --------------------------------------------------
// routes.put('/:id', (req, res) => {
//   const unam = getUnam(req);

//   const { id } = req.params;
//   const todo = { name: req.body.name, done: req.body.done };
//   repository.updateById(id, todo)
//     .then(res.status(200).json([]))
//     .catch(handleError);
// });

// delete a todo item --------------------------------------------------
// routes.delete('/:id', (req, res) => {
//   const { id } = req.params;

//   repository.deleteById(id).then((ok) => {
//     console.log(ok);
//     console.log(`Deleted record with id: ${id}`);
//     res.status(200).json([]);
//   }).catch(handleError);
// });

module.exports = routes;
