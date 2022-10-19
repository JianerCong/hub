import { assert, expect, test ,describe, beforeEach} from 'vitest';

import {sideBarObj} from '../pages/index/sideBarObj.js';
import {todoObj, makeTodo} from '../pages/index/todoObj.js';
todoObj.methods.remoteGetTodosAndOpenid = () => {console.log('skipped')};

test.skip('Math.sqrt()', () => {
  expect(Math.sqrt(4)).toBe(2);
});

test('setData', () => {
  let o1,o2;
  o1 = {x: 1, z: 1};
  o2 = {x: 2, y: 2};
  o1 = Object.assign(o1, o2);
  expect(o1).toEqual({x:2, y: 2, z:1});
});

function makePageReady(b) {
  let p = new Object(b);
  // give it the setData property
  p.setData = function(o) {this.data = Object.assign(this.data,o);};
  // mock functions
  p.animate = () => {};

  // "import" all it's "methods"
  p = Object.assign(p, p.methods);

  p.onLoad();
  return p;
}

// add the setData Function
function makeBehaviourReady(b) {
  // give it the setData property
  let p = new Object(b);
  p.setData = function(o) {
    this.data = Object.assign(this.data,o);
  };

  // "import" all it's "methods"
  p = Object.assign(p, p.methods);

  return p;
}

describe('drawer behaviour', () => {
  beforeEach(() => {
    console.log('cleaning page');
  });

  test('initially not visible', () => {
    let sb = makeBehaviourReady(sideBarObj);

    expect(sb.data.visible).toBe(false);
  });

  test('open drawer', () => {
    let sb = makeBehaviourReady(sideBarObj);

    sb.openPopUp();

    expect(sb.data.visible).toBe(true);
  });

  test('open and close drawer', () => {
    let sb = makeBehaviourReady(sideBarObj);

    sb.openPopUp();
    sb.onVisibleChange({detail: {visible: false}});

    expect(sb.data.visible).toBe(false);
  });
});

const DAY = 1e3 * 3600 * 24;
test('todoToUpload', () => {
  let todo = makeTodo('a1', false, Date.now() + 2*DAY);
  let toUpload = todo.todoToUpload;
  expect(toUpload.name).toBe('a1');
  expect(toUpload.done).toBe(false);
  expect(toUpload.ddl).toBe(todo.ddlString);
});

describe('Basic todo behaviour', () => {
  test('initial todos', () => {
    let td = makePageReady(todoObj);

    expect(td.data.todos).toEqual([]);
  });

  test('pushTodo', () => {
    let td = makePageReady(todoObj);

    let id0 = td.pushTodo(makeTodo('a1'));
    let id1 = td.pushTodo(makeTodo('a2', true));
    let id2 = td.pushTodo(makeTodo('a3', false, Date.now() + 2* DAY));

    expect(td.data.todos).toEqual([
      {name: 'a1', done: false, id: id0},
      {name: 'a2', done: true, id: id1},
      {name: 'a3', done: false, id: id2, dueInDays: 2}, // a todo with ddl
    ]);
  });

  test('clearTodo', () => {
    let td = makePageReady(todoObj);

    td.pushTodo(makeTodo('a1'));
    td.pushTodo(makeTodo('a2', true));
    td.pushTodo(makeTodo('a3', false, Date.now() + 2* DAY));
    td.clearTodo();

    expect(td.data.todos).toEqual([]);
  });

  test('submit', () => {
    let td = makePageReady(todoObj);

    td.data.input = 'a1';
    td.submit();

    // expect(td.data.todos).toEqual([{name:'a1', done:false, id: 0}]);
    expect(td.data.todos.length).toEqual(1);
    expect(td.data.todos[0]).toMatchObject({name:'a1', done:false});
    expect(td.data.input).toEqual('');
  });
  test('removeTodo', () => {
    let td = makePageReady(todoObj);

    let id0 = td.pushTodo(makeTodo('a1'));
    let id1 = td.pushTodo(makeTodo('a2'));
    let id2 = td.pushTodo(makeTodo('a3'));

    td.removeTodo(id1);
    let id3 = td.pushTodo(makeTodo('a4'));

    expect(td.data.todos).toEqual([
      {name: 'a1', done: false, id: id0},
      {name: 'a3', done: false, id: id2},
      {name: 'a4', done: false, id: id3},
    ]);
  });
  test('toggleDone', () => {
    let td = makePageReady(todoObj);

    let id0 = td.pushTodo(makeTodo('a1'));
    let id1 = td.pushTodo(makeTodo('a2'));
    td.toggleDone(id0);

    expect(td.data.todos).toEqual([
      {name: 'a1', done: true, id: id0},
      {name: 'a2', done: false, id: id1},
    ]);
  });

  test('updateTodo', () => {
    let td = makePageReady(todoObj);

    let id0 = td.pushTodo(makeTodo('a1'));
    let id1 = td.pushTodo(makeTodo('a2'));
    let todo = td.m.todos.get(id0);
    todo.name = 'something';
    todo.done = true;
    td.updateTodo(todo);

    expect(td.data.todos).toEqual([
      {name: 'something', done: true, id: id0},
      {name: 'a2', done: false, id: id1},
    ]);
  });

  test('todosToUpload' ,() => {
    let td = makePageReady(todoObj);

    let date = new Date(Date.now() + 2 * DAY);
    td.pushTodo(makeTodo('a0'));
    td.pushTodo(makeTodo('a1', true));
    td.pushTodo(makeTodo('a2', true, Date.now() + 2 * DAY));

    let d =  date.toISOString().substring(0, 10);

    expect(td.todosToUpload()).toEqual([
      {name: 'a0', done: false, ddl: ''},
      {name: 'a1', done: true, ddl: ''},
      {name: 'a2', done: true, ddl: d},
    ]);

  });
});

describe('ddlSubmit', () => {
  test('change the todo name', () => {
    let td = makePageReady(todoObj);

    let id0 = td.pushTodo(makeTodo('a1'));
    let id1 = td.pushTodo(makeTodo('a2'));

    td.openDdlBox({ currentTarget : {dataset: {id: id0}}});
    td.setData({
      ddlName: 'A1'
    });

    let oldTodo = td.m.todos.get(id0);
    let newTodo = td.ddlSubmit();
    expect(newTodo.name).toBe('A1');
    expect(newTodo.done).toBe(oldTodo.done);
    expect(newTodo.ddl).toBe(undefined);
    expect(newTodo).toEqual( td.m.todos.get(id0));
  });


  test.each([
    {nDays: undefined, c: 'today', nDays2: 0, }, // from no_ddl to today
    {nDays: undefined, c: 'tomorrow', nDays2: 1, }, // from no_ddl to tomorrow
    {nDays: undefined, c: 'day_after_tomorrow', nDays2: 2, }, // from no_ddl to day after tomorrow

    {nDays: 0, c: 'day_after_tomorrow', nDays2: 2, }, // from today to day after tomorrow
    {nDays: 1, c: 'day_after_tomorrow', nDays2: 2, }, // from tomorrow to day after tomorrow
    {nDays: 111, c: 'day_after_tomorrow', nDays2: 2, }, // from custom date to day after tomorrow


    {nDays: 0, c: 'no_ddl', nDays2: undefined, }, // remove the ddl of today
    {nDays: 1, c: 'no_ddl', nDays2: undefined, }, // remove the ddl of tomorrow

    {nDays: 0, c: 'pick_date', nDays2: 111, }, // from today to custom date
    {nDays: undefined, c: 'pick_date', nDays2: 111, }, // from no_ddl to custom date

  ])('.submit($nDays, $c, $nDays2)', ({nDays, c, nDays2}) => {

    let td = makePageReady(todoObj);
    // add a todo
    let id;
    if (nDays !== undefined) {
      id = td.pushTodo(makeTodo('a1', false, Date.now() + nDays * DAY));
    } else {
      id = td.pushTodo(makeTodo('a1'));
    }

    // open the box and select the choice
    td.openDdlBox({ currentTarget : {dataset: {id: id}}});
    td.setData({ddlChoiceIndex: td.data.ddlChoices.indexOf(c)});
    if (c === 'pick_date') {
      // pick a date
      td.setData({customDate: Date.now() + nDays2 * DAY});
    };

    let oldTodo = td.m.todos.get(id);
    let newTodo = td.ddlSubmit();

    expect(newTodo.name).toBe('a1');
    expect(newTodo.done).toBe(oldTodo.done);
    expect(newTodo).toEqual( td.m.todos.get(id));
    if (c === 'no_ddl') {
      expect(newTodo.dueInDays).toBeUndefined();
    } else {
      expect(newTodo.dueInDays).toBe(nDays2);
    }
  });
});

describe('openDdlBox', () => {
  test.each([
    {nDays: undefined, expectedChoice: 'no_ddl'}, // the default
    {nDays: 0, expectedChoice: 'today'},
    {nDays: 1, expectedChoice: 'tomorrow'},
    {nDays: 2, expectedChoice: 'day_after_tomorrow'},
  ])('.openDdlBox($nDays, $expectedChoice)', ({nDays, expectedChoice}) => {

    let td = makePageReady(todoObj);

    let id;
    if (nDays !== undefined) {
      id = td.pushTodo(makeTodo('a1', false, Date.now() + nDays * DAY));
    } else {
      id = td.pushTodo(makeTodo('a1'));
    }

    // open the box for the first todo
    let box = td.openDdlBox({ currentTarget : {dataset: {id}}});

    let todayString = (new Date()).toISOString().substring(0, 10);
    expect(box.id).toBe(id);
    expect(box.choiceId).toBe(td.data.ddlChoices.indexOf(expectedChoice));
    expect(box.name).toBe('a1');
    expect(box.customDate).toBe(todayString);
  });

  test('openDdlBox with custom Date', () => {
    let td = makePageReady(todoObj);
    let d = new Date( Date.now() + 4 * DAY);
    let id = td.pushTodo(makeTodo('a1', false, d));

    // open the box for the first todo
    let box = td.openDdlBox({ currentTarget : {dataset: {id}}});

    expect(box.id).toBe(id);
    expect(box.choiceId).toBe(td.data.ddlChoices.indexOf('pick_date'));
    expect(box.name).toBe('a1');
    expect(box.customDate).toBe(d.toISOString().substring(0, 10));

  });

});
