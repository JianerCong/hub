import { v4 as uuidv4 } from './uuid.js';

import {makeTodo, _MS_PER_DAY} from './makeTodo.js';

let todoObj = {
  // the data to render, all should be JSON-ready
  data: {
    // only data that won't be watched goes here
    ddlChoices: ['no_ddl', 'today', 'tomorrow', 'day_after_tomorrow','pick_date',],
    langChoices: ['en', 'zh'],

  },

  observers: {
    'ddlChoiceIndex' : function(ddlChoiceIndex) {
      console.log(`ddlChoiceIndex changed`);
      this.setData({
        ddlChoice: this.data.ddlChoices[ddlChoiceIndex],
      });
    },

    'lang' : function(lang) {
      console.log(`lang changed to ${lang}`);
      // the dict
      let d = {};
      let m = this.m.dict;
      // console.log(`start looping with ${[...m.keys()]}`);
      for (let [k,v] of m) {
        // console.log(`updating key for ${k}: ${v[lang]}`);
        d[k] = v[lang];
      };

      // the ddl Choices
      console.log('Updating ddlDisplayChoices');
      let ddlDisplayChoices = this.data.ddlChoices.map(s => d[s]);
      let ddlDisplayChoice = ddlDisplayChoices[this.data.ddlChoiceIndex];

      this.setData({d, ddlDisplayChoices});

      wx.setNavigationBarTitle({
        title: this.data.d['app_title']
      });
    },

    'lang,ddlChoiceIndex' : function(lang,ddlChoiceIndex) {
      this.setData({
        ddlDisplayChoice : this.data.ddlDisplayChoices[ddlChoiceIndex]
      });

    },

    // dueInDays
    'd, todos' : function(d, todos) {
      // console.log(`d and todos changed`);
      let todosDueString  = {};
      todos.forEach(todo => {
        if (todo.dueInDays !== undefined) {
          todosDueString[todo.id] =  this.dueString(todo.dueInDays, this.data.d);
        }
      });

      // console.log(`due strings ${JSON.stringify(todosDueString)}`);
      this.setData({todosDueString});
    },

    // progressPercentage
    'todos' : function(todos) {
      let p = 0;
      if (todos.length > 0) {
        let done = 0;
        todos.forEach(todo => { if (todo.done) {done++;}});
        p = 100 *  done / todos.length;
      };
      this.setData({progressPercentage: Math.round(p)});
},

  },

  methods: {
    onLoad: function() {
      // my data
      this.m = {
        todos: new Map(),
        todoId: 0,

        dict: new Map (Object.entries(
          {
            app_title: {en: 'Todo List', zh: '代办清单'},
            add_todo: {en: 'Add Todo', zh: '输入任务'},
            lang: {en: 'language', zh: '语言'},

            // dict content goes here
            edit_this: { en: 'Edit this item', zh: '编辑这件事' },
            today: { en: 'Today', zh: '今天' },
            tomorrow: { en: 'Tomorrow', zh: '明天' },
            day_after_tomorrow: { en: 'Day After Tomorrow', zh: '后天' },
            pick_date: { en: 'Pick a Date', zh: '选一天' },
            no_ddl: { en: 'No Deadline', zh: '没期限' },


            due_in_days: { en: 'due in {0} days', zh: '还有 {0} 天' },

            due_yesterday: { en: 'due yesterday', zh: '昨天到期' },
            over_due_in_days: { en: '{0} days over due', zh: '已过期 {0} 天' },
            due_today: { en: 'due today', zh: '就在今天' },
            due_tomorrow: { en: 'due tomorrow', zh: '就在明天' },
            due_day_after_tomorrow: { en: 'due day after tomorrow', zh: '在后天' },
          }))
      };



      // init the render data: this triggers the obervers
      this.setData({
        // todo related
        input: '',
        todos: [],
        activeValues: [0],


        // to change the detail editor
        ddlBoxVisible: false,
        ddlCurrentId: 0,
        ddlName: '',
        ddlChoiceIndex: 0,
        CustomDate: '',

        lang: 'en',
      });
    },

    dueString(d, dc) {
      // add a custom format method
      // First, checks if it isn't implemented yet.
      if (!String.prototype.format) {
        String.prototype.format = function () {
          var args = arguments;
          return this.replace(/{(\d+)}/g, function (match, number) {
            return typeof args[number] != 'undefined' ? args[number] : match ;
          });
        };
      }

      let s;
      if (d === 0) {
        s = dc['due_today'];
      } else if (d === 1) {
        s = dc['due_tomorrow'];
      } else if (d === 2) {
        s = dc['due_day_after_tomorrow'];
      } else if (d === -1) {
        s = dc['due_yesterday'];
      } else if (d < -1) {
        s = dc['over_due_in_days'].format(-d);
      } else {
        s = dc['due_in_days'].format(d);
      }
      /* let s = `due in ${d} days` */
      return s;
    },

    switchLang() {
      console.log(`switching language`);
      const lc = this.data.langChoices;
      let i = lc.indexOf(this.data.lang);
      i = (i + 1) % lc.length;
      this.setData({
        lang: this.data.langChoices[i]
      });

      wx.setNavigationBarTitle({
        title: this.data.d['app_title']
      });
    },

    bindDdlNameInput(e) {
      this.setData({
        ddlName: e.detail.value
      });
    },

    ddlSubmit() {
      const ddlChoice = this.data.ddlChoices[this.data.ddlChoiceIndex];
      const ddlName = this.data.ddlName;
      const id = this.data.ddlCurrentId;

      let todo = this.m.todos.get(id);
      let newTodo;
      if (ddlChoice !== 'no_ddl') {
        newTodo = makeTodo(ddlName, todo.done, ddlChoiceToDate(ddlChoice, this.data.customDate));
      } else {
        newTodo = makeTodo(ddlName, todo.done);
      }

      newTodo.id = id;
      console.log(`submmiting choice: ${ddlChoice}, ${ddlName} for todo ${id} to ${JSON.stringify(newTodo)}`);
      this.updateTodo(newTodo);
      this.ddlCloseBox();

      return newTodo;

      function ddlChoiceToDate(c, customDate) {
        let d = new Date();
        switch (c) {
        case 'today':
          break;
        case 'tomorrow':
          // increment the date
          d.setDate(d.getDate() + 1);
          break;
        case 'day_after_tomorrow':
          d.setDate(d.getDate() + 2);
          break;
        case 'pick_date':
          d = new Date(customDate);
          break;
        default:
          throw new Error('unknown key');
        }
        return d;
      };

    },

    openDdlBox(e) {
      // console.log(`opening ddl box for ${JSON.stringify(e)}`);
      const id = e.currentTarget.dataset.id;
      console.log(`opening ddl box for id: ${id}`);
      const todo =  this.m.todos.get(id);

      // set the ddlChoice accroding to todo.ddl:

      let customDate = (new Date()).toISOString().substring(0, 10);
      let ddlChoice;

      let choiceId = 0;
      if (todo?.ddl) {
        let d = todo.ddl;

        if (isToday(d)) {
          ddlChoice = 'today';
        } else if (isTomorrow(d)) {
          ddlChoice = 'tomorrow';
        } else if (isDayAfterTomorrow(d)) {
          ddlChoice = 'day_after_tomorrow';
        } else {
          ddlChoice = 'pick_date';
          customDate = todo.ddlString;
        }

        choiceId = this.data.ddlChoices.indexOf(ddlChoice);
      }

      console.log(`DdlBox opened with choiceId = ${choiceId}, customDate=${customDate}`);
      this.setData({
        ddlBoxVisible : true,
        ddlCurrentId: id,
        ddlChoiceIndex: choiceId,
        ddlName: todo.name,
        customDate,
      });

      return {id, customDate, choiceId, name: todo.name,};
    },

    ddlCloseBox() {
      console.log(`onDdlVisibleChange() called, clossing menu`);
      // const { visible } = detail;
      // this.setData({ddlBoxVisible: visible});
      this.setData({ddlBoxVisible: false});
    },

    removeDdl() {
      this.setData({
        ddlChoiceIndex: 0       // set the choice to no_ddl
      });
    },

    bindPickerChange(e) {
      console.log(`picker发送选择改变 for [${this.data.ddlName}]，携带值为`,
                  e.detail.value);
      this.setData({
        ddlChoiceIndex: e.detail.value
      });
    },

    bindCustomDateChange(e) {
      console.log(`picker发送选择改变 for [${this.data.ddlName}]，携带值为`,
                  e.detail.value);
      this.setData({
        customDate : e.detail.value
      });
    },


    bindKeyInput(e) {
      // console.log(`bindkey trigger with ${JSON.stringify(e.detail)}`);
      this.setData({
        input: e.detail.value
      });
    },

    handleChange(e) {
      console.log(e.detail);
      this.setData({
        activeValues: e.detail.value,
      });
    },

    submit(e) {
      console.log(`submitting ${this.data.input}`);
      this.pushTodo(makeTodo(this.data.input));
      this.setData({input: ''});
    },

    updateDisplayTodo() {
      if (this.m.todos.size === 0) {
        this.setData({todos: []});
      } else {
        // the array of  todos
        const todoToDisplay = [...this.m.todos.values()].
              map( o => {
                let b = {name: o.name, done: o.done, id: o.id,};
                if (o.ddl) {b.dueInDays = o.dueInDays;}
                return b ;
              });
        this.setData({todos: todoToDisplay});
      }
    },

    updateTodo(todo) {
      if (!this.m.todos.has(todo.id)) {
        throw new Error(`Updating an non-existing id = ${todo.id}`);
      }
      // update the todo item
      this.m.todos.set(todo.id, todo);
      this.updateDisplayTodo();
    },

    tapToggleDone(event) {
      // for <view> the target is the event.currentTarget, while for checkerbox,
      // it's event.target
      const clear = () => {
        this.clearAnimation(cl,
                            // {opacity: true},  // no need to clear opacity
                            () => {
                              // console.log(`animation on ${cl} cleared`);
                            }
                           );
      };
      // -------------------------------------------------- 
      const target = event.currentTarget;
      const id = target.dataset.id;
      // console.log(`event is ${JSON.stringify(event)}`);
      // animate > toggle > animate
      const cl = `.checker-box-${id}`;
      const cl2 = `.todo-text-${id}`;
      // -------------------------------------------------- 
      // console.log(`animating ${cl} and ${cl2}`);
      const ms = 200;           // time to fade in ms
      this.animate( cl2 ,[{opacity: 1.0}, {opacity: 0},], ms);
      this.animate( cl ,[{opacity: 1.0}, {opacity: 0},], ms,() => this.toggleDone(id));
      // then toggle done
      // -------------------------------------------------- 
      // do not clear animation
      this.animate( cl2 ,[{opacity: 0}, {opacity: 1.0},], ms); // then show
      this.animate( cl ,[{opacity: 0}, {opacity: 1.0},], ms, clear); // then show
    },

    toggleDone(id){
      if (this.m.todos.has(id)){
        let todo = this.m.todos.get(id);
        todo.done = !todo.done;
        this.m.todos.set(id,todo);
        this.updateDisplayTodo();
      }
      // console.log(`Now the todos ${JSON.stringify(this.data.todos)}`);
    },

    tapRemoveTodo(e) {
      console.log(`removing target= ${JSON.stringify(e.target)}`);
      this.removeTodo(e.target.dataset.id);
    },

    removeTodo(id) {
      // console.log(`removing todo[${id}]`);
      this.m.todos.delete(id);
      const cl = `.todo-box-${id}`;

      const ms = 200;
      // const y = (5 + 2.4 * 2 + 5 * 2 + 24.8);
      const y = 30;

      // for all todos whose id > this id (below this todo)
      // for (let i = this.data.todos.length;
      //      this.data.todos[i].id !== id;
      //      i--
      //     ) {
      //   let id1 = this.data.todos[i].id; // id to lift
      //   console.log(`lifting ${id1}`);
      //   let cl2 = `.todo-box-${id1}`;
      //   this.animate(cl2,[
      //     {translateY: 0,                              },
      //     {translateY: - y, },
      //   ], ms,
      //                () => {
      //                  this.clearAnimation(cl2, {
      //                    translateY: true,
      //                    // opacity: false
      //                  },
      //                                      () => {
      //                                        console.log(`animation cleared for ${cl2}`);
      //                                      }
      //                                     );
      //                }
      //               );
      // }

      // animate a fade out before deleting
      this.animate(cl, [
        {opacity: 1.0, translateX: 0},
        {opacity: 0.0, translateX: 10},
      ], ms, () => {
        // when animation is finished
        this.updateDisplayTodo();
        // setTimeout(50, () => {});
      });
    },

    clearTodo() {
      this.m.todos.clear();
      this.m.todoId = 0;
      this.updateDisplayTodo();
    },

    // todo
    pushTodo(todo) {
      // give it an id
      // let id = this.m.todoId++;
      let id = uuidv4();

      todo.id = id;

      this.m.todos.set(id, todo);
      this.updateDisplayTodo();

      const cl = `.todo-box-${id}`;
      // this set the opacity to 1, which is set to 0 in CSS
      // we do not clear the animation on purpose
      this.animate(cl, [
        {opacity: 0.0, translateX: 10},
        {opacity: 1.0, translateX: 0},
      ], 500);

      return id;
    },

    addThreeTodos() {
      // for testing only
      const DAY = 1e3 * 3600 * 24;
      this.pushTodo(makeTodo('a1'));
      this.pushTodo(makeTodo('a2',true));
      this.pushTodo(makeTodo('a3',false, Date.now() + 2 * DAY));
      this.pushTodo(makeTodo('a4',false, Date.now() - 2 * DAY));
    },

    todosToUpload() {
      let tu;
      if (this.m.todos.size === 0) {
        tu = [];
      } else {
        // the array of  todos
        tu = [...this.m.todos.values()].
              map( o => o.todoToUpload);
      }
      return tu;
    },
  }

};

function onSameDate(d1,d2) {
  let s1 = (new Date(d1)).toDateString();
  let s2 = (new Date(d2)).toDateString();
  /* console.log(`comapring ${s1} and ${s2}`) */
  return s1 === s2;
}

function incrementDate(d, n=1) {
  let d0 = new Date(d);
  d0.setDate(d.getDate() + n);
  return d0;
}

function isToday(d) {
  let today = new Date();
  return onSameDate(today, d);
}
function isTomorrow(d) {
  let today = new Date();
  return onSameDate(incrementDate(today), d);
}
function isDayAfterTomorrow(d) {
  let today = new Date();
  return onSameDate(incrementDate(today,2), d);
}


export {makeTodo,todoObj};
