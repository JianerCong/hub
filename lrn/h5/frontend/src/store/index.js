import { createStore } from 'vuex';

export default createStore({
  state: {
    unam: '',
    online: false,
    todos: new Map(),
    lang_id: 0,
    AVAILABLE_LANG: ['zh','en'],
    todo_id: 0,
  },
  getters: {
    lang(state) {
      return state.AVAILABLE_LANG[state.lang_id];
    },
    todosArray(state) {
      return [...state.todos.values()];
    },
    onlineCondition(state) {
      let condition;
      if (process.env.NODE_ENV === 'production') {
        // console.log('testing online in production mode');
        condition = state.online && (state.unam !== '');
      } else {
        // console.log('testing online in non-production mode');
        condition = state.online;
      }

      return condition;
}
  },

  mutations: {
    nextLang(state){
      state.lang_id++;
      state.lang_id %= state.AVAILABLE_LANG.length;
      document.documentElement.lang = state.AVAILABLE_LANG[state.lang_id];
    },
    setUnam(state, unam){
      state.unam = unam;
    },
    setOnline(state, val){
      state.online = val;
    },

    clearTodos(state){
      state.todos.clear();
      state.todo_id = 0;
    },

    pushTodo(state,todo){
      // give the todo an unique id
      let id = state.todo_id++;

      // add the todo item
      // set an invisible property
      Object.defineProperty(todo, "_id", {
        value: id,
        writable: true,
        enumerable: false,
        configurable: false
      });

      // add to map
      state.todos.set(id,todo);
    },

    updateTodo(state,todo) {
      if (!state.todos.has(todo._id)) {
        throw new Error(`Updating an non-existing id = ${todo._id}`);
      }
      // update the todo item
      state.todos.set(todo._id, todo);
    },

    removeTodo(state,id){
      console.log(`Removing item ${state.todos.get(id).name}`);
      state.todos.delete(id);/* remove the  ith element*/
    },

    toggleDone(state,id){
      let todos = state.todos;
      if (todos.has(id)){
        let todo = state.todos.get(id);
        todo.done = !todo.done;
        state.todos.set(id,todo);
      }
    },

  },
  actions: {
  },
  modules: {
  }
});
