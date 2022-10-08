import { mount } from '@vue/test-utils';
import { createStore } from 'vuex';

import myStore from '../src/store/index.js';
import HelloWorld from '../src/components/HelloWorld.vue';
import {makeTodo} from '../src/makeTodo.js';

describe('offline tests', () => {
  test('mount component', async () => {
    expect(HelloWorld).toBeTruthy();
  });

  test('add a todo', () => {
    const wrapper = mount(HelloWorld,{
      global: {
        plugins: [myStore],
      }
    });
    let vm = wrapper.vm;

    vm.clearTodos();               // empty the todos
    vm.input = 'aaa';

    vm.addTodo();
    assert.deepEqual([...vm.todos.values()],[
      {name: 'aaa', done: false,},
    ]);
  });


  test('delete a todo', () => {
    const wrapper = mount(HelloWorld,{
      global: {
        plugins: [myStore],
      }
    });
    let vm = wrapper.vm;

    vm.clearTodos();               // empty the todos
    vm.input = 'aaa'; vm.addTodo(); // add one
    vm.input = 'bbb'; vm.addTodo(); // add another
    vm.remove(0);                   // delete the first

    assert.deepEqual(vm.todosArray,
                     [{name: 'bbb', done: false,},
                     ]);
  });

  test('mark a todo', () => {
    const wrapper = mount(HelloWorld,{
      global: {
        plugins: [myStore],
      }
    });
    let vm = wrapper.vm;

    vm.clearTodos();               // empty the todos
    vm.input = 'aaa'; vm.addTodo(); // add one
    vm.toggleDone(0);                   // do the first
    vm.input = 'bbb'; vm.addTodo(); // add another

    assert.deepEqual(vm.todosArray,[
      {name: 'aaa', done: true,},
      {name: 'bbb', done: false,},
    ]);
  });

});

describe('online tests', () => {
  beforeEach( async () => {
    const wrapper = mount(HelloWorld,{
      global: {
        plugins: [myStore],
      }
    });
    console.log('Cleaning local and remote');
    wrapper.vm.clearTodos();
    console.log('todos cleared locally');
    if (wrapper.vm.online) {
      console.log('Cleaning remote todos');
      await wrapper.vm.http.delete('/').catch(err => {
        console.log(`got error ${err}`);
      });
    } else {
      console.log('backend down: not cleaning there');
}
  });

  test('test fetchAll()', async () =>{
    const wrapper = mount(HelloWorld,{
      global: {
        plugins: [myStore],
      }
    });

    let vm = wrapper.vm;
    assert.deepEqual(vm.todosArray,[],'Initial todos');
    // add two in the local
    vm.input = 'bbbbbbb'; vm.addTodo(); // add another
    vm.input = 'ccccccc'; vm.addTodo();
    vm.toggleDone(1);                   // do this

    if (vm.online){
      console.log('testing online fetchAll()');
      // add two items to the remote, and one that already exists in local
      await vm.http.post('/',{name:'ccccccc'}).catch(err => console.log(err));
      await vm.http.post('/',{name:'ddddddd'}).catch(err => console.log(err));
      await vm.http.post('/',{name:'aaaaaaa'}).catch(err => console.log(err));

      // fetchAll(), now there should have 4
      await vm.fetchAll();

      // The two items that does not exist in the local todo list should have been
      // added.
      //console.log(vm.todos);
      assert.deepEqual(vm.todosArray,[
        { name: 'bbbbbbb', done: false,},
        { name: 'ccccccc', done: true,}, // this item should not be overwritten by the remote
        { name: 'ddddddd', done: false},
        { name: 'aaaaaaa', done: false,},
      ],'Afterwards todos');
    }
  });


  test('test sync()', async () =>{
    const wrapper = mount(HelloWorld,{
      global: {
        plugins: [myStore],
      }
    });

    let vm = wrapper.vm;

    assert.deepEqual(vm.todosArray,[],'Initial todos');


    if (vm.online){

      // add two in the local
      vm.input = 'bbbbbbb'; vm.addTodo(); // add another
      vm.input = 'ccccccc'; vm.addTodo();
      vm.toggleDone(1);                   // do this

      // add some items to the remote, these should all be deleted
      await vm.http.post('/',{name:'xxx'}).catch(err => console.log(err));
      await vm.http.post('/',{name:'yyy'}).catch(err => console.log(err));
      await vm.http.post('/',{name: 'zzz', done: true}).catch(err => console.log(err));

      console.log('sync() manually');
      await vm.sync();

      // The two items that does not exist in the local todo list should have been
      // added.
      // console.log(vm.todos);
      let remote_todos;
      await vm.http.get('/').then(res=>{
        remote_todos = res.data.map(d => {
          return {name: d.name, done: d.done};
        });
      });

      assert.deepEqual(vm.todosArray,
                       remote_todos,'Afterwards todos');
    }
  });
});

describe('Due in days', () => {
  test('due in days', () => {

    // set the lang to 'en'
    while (myStore.getters.lang !== 'en'){
      console.log(`switching to en, now it's ${myStore.getters.lang}'`);
      myStore.commit('nextLang');
}

    // mount the component
    const wrapper = mount(HelloWorld,{
      global: {
        plugins: [myStore],
      }
    });

    // Assert
    let vm = wrapper.vm;
    expect(vm.dueString(0)).toBe(vm.d('due_today'));
    expect(vm.dueString(0)).toBe('due today');
    expect(vm.dueString(1)).toBe(vm.d('due_tomorrow'));
    expect(vm.dueString(1)).toBe('due tomorrow');

    expect(vm.dueString(2)).toBe(vm.d('due_day_after_tomorrow'));
    expect(vm.dueString(2)).toBe('due day after tomorrow');
    expect(vm.dueString(-1)).toBe(vm.d('due_yesterday'));
    expect(vm.dueString(-1)).toBe('due yesterday');

    expect(vm.dueString(10)).toBe('due in 10 days');
    expect(vm.dueString(-10)).toBe('10 days over due');
  });
});
