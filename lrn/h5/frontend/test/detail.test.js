import { mount } from '@vue/test-utils';
import DetailView from '../src/views/DetailView.vue';

import myStore from '../src/store/index.js';


test('mount DetailView component', async () => {
  expect(DetailView).toBeTruthy();
});

describe('test selecting ddl' ,() => {
  beforeEach( () => {
    console.log('Setting up store and mock router');
    myStore.commit('clearTodos');
  });

  test('select no deadline', () => {
    // add a todo in the store
    let todo2 = {name: 'a1', done: true,
                 // ddlString: undefined
                };

    myStore.commit('pushTodo',{name:'a1',done:true});

    const mockRouter = {params: {id:0}};
    const wrapper = mount(DetailView,{
      props: {id: '0'},
      global: {
        mocks: {$route: mockRouter},
        plugins: [myStore],
      }
    });
    let vm = wrapper.vm;

    vm.ddl = 'no_ddl';
    let todo = vm.todoToSubmit;
    assert.deepEqual(todo, todo2);
  });

  test('select today', () => {
    // Arrange
    // add a todo in the store
    myStore.commit('pushTodo',{name:'a1',done:true});
    const mockRouter = {params: {id:0}};
    const wrapper = mount(DetailView,{
      props: {id: '0'},
      global: {
        mocks: {$route: mockRouter},
        plugins: [myStore],
      }
    });
    let vm = wrapper.vm;

    // Act
    vm.ddl = 'today';

    // Assert
    let d = Date.now();
    const s = [
      Intl.DateTimeFormat('ISO',{year:'numeric'}).format(d),
      Intl.DateTimeFormat('ISO',{month:'2-digit'}).format(d),
      Intl.DateTimeFormat('ISO',{day:'2-digit'}).format(d)
    ].join('-');

    const todo = vm.todoToSubmit;

    // give todo2 the ddl Date() object
    expect(todo.name).toBe('a1');
    expect(todo.done).toBe(true);
    expect(todo.ddlString).toBe(s);
  });


  test('select tomorrow', () => {
    // Arrange --------------------------------------------------
    // add a todo in the store
    myStore.commit('pushTodo',{name:'a1',done:true});
    const mockRouter = {params: {id:0}};
    const wrapper = mount(DetailView,{
      props: {id: '0'},
      global: {
        mocks: {$route: mockRouter},
        plugins: [myStore],
      }
    });
    let vm = wrapper.vm;

    // Act --------------------------------------------------
    vm.ddl = 'tomorrow';

    // Assert --------------------------------------------------

    // today + 24h
    let d = new Date(Date.now().valueOf() + 1e3 * 60 * 60 * 24);
    const s = [
      Intl.DateTimeFormat('ISO',{year:'numeric'}).format(d),
      Intl.DateTimeFormat('ISO',{month:'2-digit'}).format(d),
      Intl.DateTimeFormat('ISO',{day:'2-digit'}).format(d)
    ].join('-'); //⇒ yyyy-mm-dd

    const todo = vm.todoToSubmit;

    // give todo2 the ddl Date() object
    expect(todo.name).toBe('a1');
    expect(todo.done).toBe(true);
    expect(todo.ddlString).toBe(s);

  });


  test('select day after tomorrow', () => {
    // Arrange --------------------------------------------------
    // add a todo in the store
    myStore.commit('pushTodo',{name:'a1',done:true});
    const mockRouter = {params: {id:0}};
    const wrapper = mount(DetailView,{
      props: {id: '0'},
      global: {
        mocks: {$route: mockRouter},
        plugins: [myStore],
      }
    });
    let vm = wrapper.vm;

    // Act --------------------------------------------------
    vm.ddl = 'day_after_tomorrow';

    // Assert --------------------------------------------------

    // today + 48h
    let d = new Date(Date.now().valueOf() + 1e3 * 60 * 60 * 48);
    const s = [
      Intl.DateTimeFormat('ISO',{year:'numeric'}).format(d),
      Intl.DateTimeFormat('ISO',{month:'2-digit'}).format(d),
      Intl.DateTimeFormat('ISO',{day:'2-digit'}).format(d)
    ].join('-'); //⇒ yyyy-mm-dd

    const todo = vm.todoToSubmit;

    // give todo2 the ddl Date() object
    expect(todo.name).toBe('a1');
    expect(todo.done).toBe(true);
    expect(todo.ddlString).toBe(s);

  });


  test('custom date', () => {
    // Arrange --------------------------------------------------
    // add a todo in the store
    myStore.commit('pushTodo',{name:'a1',done:true});
    const mockRouter = {params: {id:0}};
    const wrapper = mount(DetailView,{
      props: {id: '0'},
      global: {
        mocks: {$route: mockRouter},
        plugins: [myStore],
      }
    });
    let vm = wrapper.vm;

    // Act --------------------------------------------------
    vm.ddl = 'pick_date';    // any other string triggers the customdate
    vm.customDate = '2022-12-12';

    // Assert --------------------------------------------------

    // today + 48h
    const s = '2022-12-12';

    const todo = vm.todoToSubmit;

    // give todo2 the ddl Date() object
    expect(todo.name).toBe('a1');
    expect(todo.done).toBe(true);
    expect(todo.ddlString).toBe(s);

  });
});

describe('todo properties', () => {
  test('dueInDays today', () => {
    // Arrange --------------------------------------------------
    // add a todo in the store
    myStore.commit('pushTodo',{name:'a1',done:true});
    const mockRouter = {params: {id:0}};
    const wrapper = mount(DetailView,{
      props: {id: '0'},
      global: {
        mocks: {$route: mockRouter},
        plugins: [myStore],
      }
    });
    let vm = wrapper.vm;

    // Act --------------------------------------------------
    vm.ddl = 'today';    // any other string triggers the customdate

    // Assert --------------------------------------------------

    const todo = vm.todoToSubmit;
    expect(todo.dueInDays).toBe(0);
  }) ;


  test('dueInDays tomorrow', () => {
    // Arrange --------------------------------------------------
    // add a todo in the store
    myStore.commit('pushTodo',{name:'a1',done:true});
    const mockRouter = {params: {id:0}};
    const wrapper = mount(DetailView,{
      props: {id: '0'},
      global: {
        mocks: {$route: mockRouter},
        plugins: [myStore],
      }
    });
    let vm = wrapper.vm;

    // Act --------------------------------------------------
    vm.ddl = 'tomorrow';    // any other string triggers the customdate

    // Assert --------------------------------------------------

    const todo = vm.todoToSubmit;
    expect(todo.dueInDays).toBe(1);
  }) ;


  test('dueInDays day after tomorrow', () => {
    // Arrange --------------------------------------------------
    // add a todo in the store
    myStore.commit('pushTodo',{name:'a1',done:true});
    const mockRouter = {params: {id:0}};
    const wrapper = mount(DetailView,{
      props: {id: '0'},
      global: {
        mocks: {$route: mockRouter},
        plugins: [myStore],
      }
    });
    let vm = wrapper.vm;

    // Act --------------------------------------------------
    vm.ddl = 'day_after_tomorrow';    // any other string triggers the customdate

    // Assert --------------------------------------------------

    const todo = vm.todoToSubmit;
    expect(todo.dueInDays).toBe(2);
  }) ;

  test('dueInDays some days later', () => {
    // Arrange --------------------------------------------------
    // add a todo in the store
    myStore.commit('pushTodo',{name:'a1',done:true});
    const mockRouter = {params: {id:0}};
    const wrapper = mount(DetailView,{
      props: {id: '0'},
      global: {
        mocks: {$route: mockRouter},
        plugins: [myStore],
      }
    });
    let vm = wrapper.vm;

    // Act --------------------------------------------------
    vm.ddl = 'pick_date';    // any other string triggers the customdate
    let d = new Date();
    d.setDate(d.getDate() + 10); // 10 days later
    vm.customDate = d.toISOString().substring(0,10);

    // Assert --------------------------------------------------
    const todo = vm.todoToSubmit;
    expect(todo.dueInDays).toBe(10);
  }) ;


  test('dueInDays some days earlier', () => {
    // Arrange --------------------------------------------------
    // add a todo in the store
    myStore.commit('pushTodo',{name:'a1',done:true});
    const mockRouter = {params: {id:0}};
    const wrapper = mount(DetailView,{
      props: {id: '0'},
      global: {
        mocks: {$route: mockRouter},
        plugins: [myStore],
      }
    });
    let vm = wrapper.vm;

    // Act --------------------------------------------------
    vm.ddl = 'pick_date';    // any other string triggers the customdate
    let d = new Date();
    d.setDate(d.getDate() - 10); // 10 days later
    vm.customDate = d.toISOString().substring(0,10);

    // Assert --------------------------------------------------
    const todo = vm.todoToSubmit;
    expect(todo.dueInDays).toBe(-10);
  }) ;
});
