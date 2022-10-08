import { assert, expect, test } from 'vitest';
// import axios from axios
const axios = require('axios');

const url = 'http://localhost:9001/todos';
let http = axios.create({baseURL: url});
// Edit an assertion and save to see HMR in action


test('Math.sqrt()', () => {
  expect(Math.sqrt(4)).toBe(2);
});

test('delete all', async () => {
  let s;
  await http.delete('/').then(res=>{
    s = res.status;
  }).catch(handelError);

  expect(s).toBe(200);
});

test('get all', async () => {
  let s, data;
  await http.get('/').then( res => {
    s = res.status;
    data = res.data;
  });
  expect(s).toBe(200);
  assert.deepEqual(data,[]);   // data should be empty now
});

test('post', async () => {
  await http.delete('/');
  let s,data;

    // add two items
  await http.post('/', {name: 'aaa'}).then((res)=>{s = res.status});
  expect(s).toBe(200);
  await http.post('/', {name: 'bbb', done:true}).then((res)=>{s = res.status});
  expect(s).toBe(200);

    // get all todos
    await http.get('/').then(res=>{
      s = res.status;
      data = res.data;
    });
  expect(s).toBe(200);

  expect(data[0].name).toBe('aaa');
  expect(data[0].done).toBe(false);
  expect(data[1].name).toBe('bbb');
  expect(data[1].done).toBe(true);
});


test('get one user', async () => {
  await http.delete('/');        // clear the db
  let s,data;

  // add two items
  await http.post('/', {name: 'a1',unam: 'aaa'});
  await http.post('/', {name: 'a2',unam: 'aaa'});
  await http.post('/', {name: 'b1',unam: 'bbb'});
  await http.post('/', {name: 'b2',unam: 'bbb'});


  // get all todos
  await http.get('/',{
    data: {unam: 'aaa'}
  }).then(res=>{
    s = res.status;
    data = res.data;});
  expect(s).toBe(200);

  console.log(data);
  expect(data).toHaveLength(2);
  expect(data[0].name).toBe('a1');
  expect(data[0].done).toBe(false);
  expect(data[1].name).toBe('a2');
  expect(data[1].done).toBe(false);
});


test('get one user2', async () => {
  await http.delete('/');        // clear the db
  let s,data;

  // add two items
  await http.post('/', {name: 'a1',unam: 'aaa'});
  await http.post('/', {name: 'a2',unam: 'aaa'});
  await http.post('/', {name: 'b1',unam: 'bbb'});
  await http.post('/', {name: 'b2',unam: 'bbb'});


  // get all todos
  await http.post('/getall/', {unam: 'aaa'}).then(res=>{
    s = res.status;
    data = res.data;});
  expect(s).toBe(200);

  console.log(data);
  expect(data).toHaveLength(2);
  expect(data[0].name).toBe('a1');
  expect(data[0].done).toBe(false);
  expect(data[1].name).toBe('a2');
  expect(data[1].done).toBe(false);
});


test('post many', async () => {
  await http.delete('/');        // clear the db
  let s,data;
  // add two items

  let a = {unam:'aaa',todos:[
    {name:'a1'},
    {name:'a2',done:true},
  ]};
  await http.post('/postmany/', a).then(res=>{
    s = res.status;
  });
  expect(s).toBe(200);


  // get all todos
  await http.post('/getall/', {unam: 'aaa'}).then(res=>{
    s = res.status;
    data = res.data;});
  expect(s).toBe(200);

  console.log(data);
  expect(data).toHaveLength(2);
  expect(data[0].name).toBe('a1');
  expect(data[0].done).toBe(false);
  expect(data[1].name).toBe('a2');
  expect(data[1].done).toBe(true);
});



test('delete one user', async () => {
  await http.delete('/');        // clear the db
  let s,data;

  // add two items
  await http.post('/', {name: 'a1',unam: 'aaa'});
  await http.post('/', {name: 'a2',unam: 'aaa'});
  await http.post('/', {name: 'b1',unam: 'bbb'});
  await http.post('/', {name: 'b2',unam: 'bbb'});

  // delete aaa's data
  await http.delete('/',{
    data: {unam: 'aaa'}
  }).then(res=>{
    s = res.status;
  });
  expect(s).toBe(200);

  // get all todos
  await http.get('/').then(res=>{
    s = res.status;
    data = res.data;
  });
  expect(s).toBe(200);

  // console.log(data);
  expect(data).toHaveLength(2);
  expect(data[0].name).toBe('b1');
  expect(data[0].done).toBe(false);
  expect(data[1].name).toBe('b2');
  expect(data[1].done).toBe(false);
});



function handelError(err){
    if (err.response) {
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx
        console.log(err.response.data);
        console.log(err.response.status);
        console.log(err.response.headers);
    } else if (err.request) {
        // The request was made but no response was received
        // `err.request` is an instance of XMLHttpRequest in the browser and an instance of
        // http.ClientRequest in node.js
        console.log(err.request);
    } else {
        // Something happened in setting up the request that triggered an Err
        console.log('Err', err.message);
    }
    console.log(err.config);
}
