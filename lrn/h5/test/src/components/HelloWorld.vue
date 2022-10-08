<template>
    <div>
        <div
            v-for="todo in todos"
            :key="todo.id"
            data-test="todo"
            :class="[todo.completed ? 'completed' : '']"
        >
            {{ todo.text }}
            <input
                type="checkbox"
                v-model="todo.completed"
                data-test="todo-checkbox"
            />
        </div>

        <form data-test="form" @submit.prevent="createTodo">
            <input data-test="new-todo" v-model="newTodo" />
        </form>
    </div>
</template>

<script>
 export default {
     name: 'TodoApp',
     props: {
         msg: String
     },
     data() {
         return {
             x: 0,
             newTodo: '',
             todos: [
                 {
                     id: 1,
                     text: 'Learn Vue.js 3',
                     completed: false
                 }
             ]
         }
     },
     methods: {
         setX() {
             this.x = 42;
         },
         createTodo() {
             this.todos.push({
                 id: 2,
                 text: this.newTodo,
                 completed: false
             })
         }
     }
 }
</script>


<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
 h3 {
     margin: 40px 0 0;
 }
 ul {
     list-style-type: none;
     padding: 0;
 }
 li {
     display: inline-block;
     margin: 0 10px;
 }
 a {
     color: #42b983;
 }
</style>
