<template>
    <div>
        <!-- The nav bar -->
        <nav class="navbar navbar-expand-lg bg-secondary navbar-dark py-3 fixed-top">
            <div class="container">
                <span class="navbar-brand px-3"> {{d('edit_this')}}</span>
            </div>

        </nav>


        <!-- Options -->
        <section>
            <div class="container">
                <div class="">
                    <div class="row h2 mt-2">
                        <div class="col-2 text-center" @click="done=!done">
                            <Transition name="fade">
                                <span v-if="!done" class="position-absolute">
                                    <!-- absolute position + text-center 
                                         make the icon inserted at the center -->
                                    <i class="bi bi-square"></i>
                                </span>
                                <span v-else class="position-absolute">
                                    <i class="bi bi-check-square"></i>
                                </span>
                            </Transition>
                        </div>
                        <div class="col-10">
                            <input type="text" class="form-control" v-model="name">
                        </div>
                    </div>
                    <div class="row h3 mt-4">
                        <div class="col-2 text-center">
                            <i class="bi bi-calendar-event position-absolute"></i>
                        </div>
                        <div class="col-10">
                            <select class="form-select" v-model="ddl">
                                <option selected value="no_ddl">{{d('no_ddl')}}</option>
                                <option value="today">{{d('today')}}</option>
                                <option value="tomorrow">{{d('tomorrow')}}</option>
                                <option value="day_after_tomorrow">{{d('day_after_tomorrow')}}</option>
                                <option value="pick_date">{{d('pick_date')}}</option>
                            </select>
                        </div>
                    </div>

                    <div class="row h3 mt-4" v-show="ddl === 'pick_date'">
                        <div class="col-2 text-center"></div>
                        <div class="col-8">
                            <input type="date" id="start" name="trip-start" v-model="customDate" class="form-control"
                                   min="2018-01-01" max="2022-12-31">
                        </div>
                        <div class="col-2 text-center fs-6 d-flex align-items-center">
                            <div>
                                <button type="button" class="btn-close" @click="ddl = 'no_ddl'"></button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- submit buttons -->
        <section>
            <div class="container fixed-bottom">
                <div class="d-grid gap-2 mt-3
                            mx-auto d-md-flex justify-content-md-end
                            mb-4" style="grid-template-columns: repeat(3, 1fr);">

                    <!-- justify-content-md-end -->
                    <button class="btn btn-danger my-min-width" type="button" @click="deleteAndGoHome">
                        <span class="h3">
                            <i class="bi bi-trash-fill"></i>
                        </span>
                    </button>
                    <button class="btn btn-success my-min-width" type="button" @click="updateAndGoHome">
                        <span class="h3">
                            <i class="bi bi-check"></i>
                        </span>
                    </button>
                    <button class="btn btn-secondary my-min-width" type="button" @click="toHome">
                        <span class="h3">
                            <i class="bi bi-x"></i>
                        </span>
                    </button>
                </div>
            </div>
        </section>
    </div>
</template>

<script>
 import f from './common_for_login_signup.js'
 import { ref, watch, computed } from 'vue';
 import { useStore } from 'vuex';
 import {makeTodo} from '../makeTodo.js'

 function onSameDate(d1,d2) {
     let s1 = (new Date(d1)).toDateString()
     let s2 = (new Date(d2)).toDateString()
     /* console.log(`comapring ${s1} and ${s2}`) */
     return s1 === s2
 }

 function incrementDate(d, n=1) {
     let d0 = new Date(d)
     d0.setDate(d.getDate() + n)
     return d0
 }

 function isToday(d) {
     let today = new Date()
     return onSameDate(today, d)
 }
 function isTomorrow(d) {
     let today = new Date()
     return onSameDate(incrementDate(today), d)
 }
 function isDayAfterTomorrow(d) {
     let today = new Date()
     return onSameDate(incrementDate(today,2), d)
 }

 export default {
     name: 'DetailView',
     created() {
         let { id } = this.$route.params
         id = Number(id)

         console.log(`detail view called with id = ${id}`)

         this.id = id
         let todo = this.$store.state.todos.get(id)
         this.name = todo.name
         this.done = todo.done


         if (todo?.ddl) {
             let d = todo.ddl

             if (isToday(d)) {
                 this.ddl = 'today'
             } else if (isTomorrow(d)) {
                 this.ddl = 'tomorrow'
             } else if (isDayAfterTomorrow(d)) {
                 this.ddl = 'day_after_tomorrow'
             } else {
                 this.ddl = 'pick_date'
                 this.customDate = todo.ddlString
             }

         }
     },
     setup() {
         const dict = {
             // dict content goes here
             edit_this: { en: 'Edit this item', zh: '编辑这件事' },
             today: { en: 'Today', zh: '今天' },
             tomorrow: { en: 'Tomorrow', zh: '明天' },
             day_after_tomorrow: { en: 'Day After Tomorrow', zh: '后天' },
             pick_date: { en: 'Pick a Date', zh: '选一天' },
             no_ddl: { en: 'No Deadline', zh: '没期限' },
         }

         let id = ref(0)

         let done = ref(true)
         let name = ref('')
         let ddl = ref('no_ddl')
         let customDate = ref('')

         const todoToSubmit = computed(() => {
             let todo = { name: name.value, done: done.value }
             if (ddl.value === 'no_ddl') {
                 return todo
             }

             console.log('Adding ddl')
             let d = new Date();
             switch (ddl.value) {
                 case 'today':
                     break;
                 case 'tomorrow':
                     // increment the date
                     d.setDate(d.getDate() + 1)
                     break;
                 case 'day_after_tomorrow':
                     d.setDate(d.getDate() + 2)
                     break;
                 case 'pick_date':
                     d = new Date(customDate.value)
                     break;
                 default:
                     throw new Error('unknown key')
             }

             todo = makeTodo(name.value, done.value, d)
             // the method created through meta-programming won't should up in JSON?
             console.log(`todo to be submitted is ${JSON.stringify(todo)}`)

             return todo
         })

         watch(ddl, (newVal) => {
             console.log(`ddl now: ${newVal}`)
         })

         watch(customDate, (newVal) => {
             console.log(`customDate now: ${newVal}`)
         })


         let s = useStore()
         function deleteAndGoHome() {
             console.log(`Removing todo ${id.value}`)
             s.commit('removeTodo', id.value)
             toHome()
         }

         function updateAndGoHome() {
             let todo = todoToSubmit.value
             todo._id = id.value
             console.log(`Updating todo ${id.value} with ${JSON.stringify(todo)}`)
             console.log(`the ddlString is ${todo.ddlString}`)
             s.commit('updateTodo', todo)
             toHome()
         }

         const { lang, toHome } = f()
         function d(key) {
             const s = dict[key][lang.value]
             // console.log(`d called with ${key}, lang=${lang.value}, val=${s}`)
             return s
         }
         return {
             id, done, name, ddl,
             todoToSubmit,
             customDate,
             deleteAndGoHome,
             updateAndGoHome,
             lang, d, toHome,
         }
     }
 }
</script>

<style>
 .fade-enter-active,
 .fade-leave-active {
     transition: 0.5s;
 }

 .fade-enter-from,
 .fade-leave-to {
     opacity: 0;
 }
</style>
