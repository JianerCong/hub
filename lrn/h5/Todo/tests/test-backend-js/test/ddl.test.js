import { assert, expect, test } from 'vitest';
// import axios from axios
const axios = require('axios');

const url = 'http://localhost:9001/todos';
let http = axios.create({baseURL: url});
// Edit an assertion and save to see HMR in action


test('post with ddl', async () => {
  await http.delete('/');
  let s,data;

  // add two items
  await http.post('/', {name: 'aaa'}).then((res)=>{s = res.status;});
  // expect(s).toBe(200);
  await http.post('/', {name: 'bbb', done:true}).then((res)=>{s = res.status;});
  await http.post('/', {name: 'ccc', ddl: '2000-01-01'}).then((res)=>{s = res.status;});
  // expect(s).toBe(200);

  // get all todos
  await http.get('/').then(res=>{
    s = res.status;
    data = res.data;
  });
  expect(s).toBe(200);

  expect(data[0].name).toBe('aaa');
  expect(data[0].done).toBe(false);
  expect(data[0].ddl).toBe('');

  expect(data[1].name).toBe('bbb');
  expect(data[1].done).toBe(true);
  expect(data[1].ddl).toBe('');

  expect(data[2].name).toBe('ccc');
  expect(data[2].done).toBe(false);
  expect(data[2].ddl).toBe('2000-01-01');
});


test('post many with ddl', async () => {
  await http.delete('/');        // clear the db
  let s,data;
  // add two items

  let a = {unam:'aaa',todos:[
    {name:'a1', ddl: '2000-01-01'},
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
  expect(data[0].ddl).toBe('2000-01-01');
  expect(data[1].name).toBe('a2');
  expect(data[1].done).toBe(true);
  expect(data[1].ddl).toBe('');
});
