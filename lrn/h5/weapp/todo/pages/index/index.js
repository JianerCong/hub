// index.js
// 获取应用实例
// const app = getApp()

// all weApp-related behaviours should be here ⇒ easier testing
import {todoObj, makeTodo} from './todoObj.js';
import {sideBarObj} from './sideBarObj.js';
// import {todoObj} from './todoObj.js';

// push three todos on load

todoObj.behaviors =  [Behavior(sideBarObj),];

let p = new Object(todoObj);
const DEV = false;
const ONLINE = true;
if (DEV) {
  // for dev only, add some todos for show
  p.setData = function(o) {
    this.data = Object.assign(this.data,o);
  };

  // "import" all it's "methods"
  p = Object.assign(p, p.methods);

  p.onLoad();
  const DAY = 1e3 * 3600 * 24;
  p.pushTodo(makeTodo('a1'));
  p.pushTodo(makeTodo('a2', true));
  p.pushTodo(makeTodo('a3',false, Date.now() + 2 * DAY));
  delete p.setData;       // important, don't play with it's internal framework
}

Component(p);
