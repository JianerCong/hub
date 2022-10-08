<template>
    <div>
        <!-- The nav bar -->
        <nav class="navbar navbar-expand-lg bg-secondary navbar-dark py-3 fixed-top">
            <div class="container">
                <a href="#" class="navbar-brand">
                    <!-- {{d('app_name')}} -->
                    <img v-if="lang=='zh' && light" src="../assets/aTodoList-zh_dark.png" class="py-0"
                        style="height: 1.9em;">
                    <img v-else-if="lang=='zh' && !light" src="../assets/aTodoList-zh.png" class="py-0"
                        style="height: 1.9em;">
                    <img v-else-if="lang=='en' && light" src="../assets/aTodoList_dark.png" class="py-0"
                        style="height: 1.9em;">
                    <img v-else src="../assets/aTodoList.png" class="" style="height: 1.5em;">
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navmenu">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navmenu">
                    <ul class="navbar-nav ms-auto text-end">

                        <!-- online icon-->
                        <li class="nav-item mt-2">
                            <span class="badge text-bg-success" >
                                <i v-if="online" class="bi bi-wifi" 
                                @click="if (unam) fetchAll();"></i>
                                <i v-else class="bi bi-wifi-off"></i>
                            </span>
                        </li>

                        <li v-show="unam !== ''" class="nav-item mt-2">
                            {{d('logged_in_as')}}:
                            <span class="badge text-bg-success">{{unam}}</span>
                        </li>
                        <li v-show="unam !== ''" class="nav-item mt-2 ">
                            <button type="button" class="btn btn-danger my-min-width" 
                            @click="logOut">Log out</button>
                        </li>

                        <li v-show="unam === ''" class="nav-item mt-2 mx-lg-2">
                            <!-- make some margin on large screen -->
                            <button type="button" class="btn btn-success my-min-width"
                                @click="clearIntervalAndPushRoute({path: '/login'})">
                                {{d('log_in_signup')}}
                            </button>
                        </li>

                        <li class="nav-item mt-2 mx-lg-2">
                            <button type="button" class="btn btn-light my-min-width" @click="nextLang">
                                {{d('change_lang')}}
                            </button>
                        </li>

                        <li class="nav-item mt-2 mx-lg-2">
                            <button type="button" class="btn btn-light my-min-width" @click="toggleLight">
                                {{light ? '☀️': '🌙'}}
                            </button>
                        </li>

                        <li class="nav-item mt-2 mx-lg-2">
                            <button type="button" class="btn btn-info my-min-width"
                                @click="clearIntervalAndPushRoute({path:'/about'})">
                                {{d('about')}}
                            </button>
                        </li>

                    </ul>
                </div>
            </div>
        </nav>

        <!-- the input bar -->
        <section class="fixed-bottom">
            <div class="container">
                <div class="input-group mb-3 ">
                    <input @keyup.enter="addTodo" type="text" class="form-control h2" v-model="input"
                        :placeholder="d('write_your_todo_here')">
                    <button @click="addTodo" class="btn btn-success h2" type="button" v-show="input !== ''">
                        <!-- {{d('add')}} -->
                        <strong>+</strong>
                    </button>
                </div>
            </div>
        </section>

        <!-- show items -->
        <section>
            <div class="container pt-4">
                <!-- Use grid -->
                <TransitionGroup name="todo-fade" tag="div">
                    <div class="row mx-3 rounded bg-secondary border lead mb-2" v-for="[id,todo] of todos" :key="id"
                        :class="{'text-light': light}">
                        <!-- the 🏑 icon -->
                        <div class="col-2 col-md-1 rounded-start " @click="toggleDone(id)">
                            <Transition name="fade">
                                <span v-if="!todo.done" class="position-absolute">
                                    <i class="bi bi-square"></i>
                                </span>
                                <span v-else class="position-absolute">
                                    <i class="bi bi-check-square"></i>
                                </span>
                            </Transition>
                        </div>
                        <!-- the item content -->
                        <div class="col-8 col-md-10 position-relative fs-4"
                            @click="
                            clearIntervalAndPushRoute({name:'detail',params: {id: id}})
                            ">
                            <div v-if="todo?.ddlString" style="min-height: 2em;">
                                <Transition name="fade">
                                    <del v-if="todo.done" class="text-muted position-absolute">{{todo.name}}</del>
                                    <span v-else class="position-absolute" 
                                    :class="{'text-danger': todo.dueInDays < 0}"
                                    >{{todo.name}}</span>
                                </Transition>
                                <!-- placeholder for the absolutely-positioned text -->
                                <span class="invisible">a</span>
                                <div class="fs-6 text-muted"
                                >
                                    {{dueString(todo.dueInDays)}}
                                </div>
                            </div>
                            <div v-else>
                                <Transition name="fade">
                                    <del v-if="todo.done" class="text-muted position-absolute">{{todo.name}}</del>
                                    <span v-else class="position-absolute">{{todo.name}}</span>
                                </Transition>
                            </div>
                        </div>
                        <!-- the 🗑 icon -->
                        <div class="col-2 col-md-1 rounded-end text-center" @click="remove(id)">
                            <i class="bi bi-x-square-fill"></i>
                        </div>
                    </div>
                </TransitionGroup>
            </div>
        </section>
    </div>
</template>

<script>
import axios from "axios"
import { handleError } from '../views/funcs.js'
import { makeTodo } from '../makeTodo.js'

export default {
    name: 'HelloWorld',
    data() {
        return {
            dict: {

                write_your_todo_here: {
                    en: 'Write your todo here',
                    zh: '在这里写你要做的事'
                },
                log_in_signup: { en: 'Log in / Sign up', zh: '登录 / 注册' },
                logged_in_as: { en: 'Logged in as', zh: '当前用户' },
                log_out: { en: 'Log out', zh: '登出' },
                app_name: { en: 'A Todo App', zh: '一个办事清单' },
                about: { en: 'About', zh: '关于' },
                add: { en: 'Add', zh: '加' },
                change_lang: { en: 'language', zh: '语言' },

                due_in_days: { en: 'due in {0} days', zh: '还有 {0} 天' },

                due_yesterday: { en: 'due yesterday', zh: '昨天到期' },
                over_due_in_days: { en: '{0} days over due', zh: '已过期 {0} 天' },
                due_today: { en: 'due today', zh: '就在今天' },
                due_tomorrow: { en: 'due tomorrow', zh: '就在明天' },
                due_day_after_tomorrow: { en: 'due day after tomorrow', zh: '在后天' },

            },
            input: "",
            http: axios.create({
                baseURL: process.env.VUE_APP_BACKEND_HOST ?
                    `https://${process.env.VUE_APP_BACKEND_HOST}/todo/todos/` :
                    'http://localhost:9001/todos'
            }),

            light: false,
            cssHref: 'litera/bootstrap.min.css',

            hook_id: 0,
        }
    },
    created: async function () {
        console.log(`HelloWorld created() called with BACKEND = ${this.http.getUri()} `)
        await this.testOnline()
        if (this.online && this.unam && this.unam !== '') await this.fetchAll()
        const f = async () => {
            await this.testOnline()
            this.sync()
        }
        await f()
        if (process.env.NODE_ENV === 'production') {
            this.hook_id = setInterval(async () => {
                console.log('trying updating from server')
                await f()
            },10000)
            console.log(`Adding interval update for production: ${this.hook_id}`);
        }
    },
    methods: {
        clearIntervalAndPushRoute(route) {
            if (process.env.NODE_ENV === 'production') {
                console.log(`Removing interval ${this.hook_id}`);
                clearInterval(this.hook_id);
            }

            this.$router.push(route);
        },
        async testOnline() {
            console.log('Testing online')
            try {
                await axios({
                    method: 'get',
                    url: this.http.getUri(),
                    timeout: 3000, //only wait for 2s
                })
                console.log('backend up')
                this.$store.commit('setOnline', true)
            } catch (err) {
                console.log(`backend down : ${err}`)
                this.$store.commit('setOnline', false)
            }
            /* await this.http.get('/hi').then(() => {
             *     this.$store.commit('setOnline',true)
             * }).catch(() => {
             *     console.log('backend down')
             *     this.$store.commit('setOnline',false)
             * }) */
        },

        dueString(d) {
            // add a custom format method
            // First, checks if it isn't implemented yet.
            if (!String.prototype.format) {
                String.prototype.format = function () {
                    var args = arguments;
                    return this.replace(/{(\d+)}/g, function (match, number) {
                        return typeof args[number] != 'undefined'
                            ? args[number]
                            : match
                            ;
                    });
                };
            }
            let s
            if (d === 0) {
                s = this.d('due_today')
            } else if (d === 1) {
                s = this.d('due_tomorrow')
            } else if (d === 2) {
                s = this.d('due_day_after_tomorrow')
            } else if (d === -1) {
                s = this.d('due_yesterday')
            } else if (d < -1) {
                s = this.d('over_due_in_days').format(-d)
            } else {
                s = this.d('due_in_days').format(d)
            }
            /* let s = `due in ${d} days` */
            return s
        },

        // switch theme
        toggleLight() {
            this.light = !this.light
            if (this.light) this.switchToLight()
            else this.removeLight()
        },
        switchToLight() {
            /* console.log('Switching to light') */
            let cssNode = document.createElement('link')
            cssNode.type = 'text/css'
            cssNode.rel = 'stylesheet'
            cssNode.media = 'screen'

            let head = document.getElementsByTagName('head')[0]
            cssNode.href = this.cssHref
            head.appendChild(cssNode)
        },
        removeLight() {
            /* console.log('Removing light') */
            let allLinks = document.getElementsByTagName('link')
            for (let link of allLinks) {
                let href = link.getAttribute('href')
                if (href && href.includes(this.cssHref)) {
                    // link.parentNode.removeChild(link)
                    link.remove()
                }
            }
        },

        // logic for todos
        remove(i) {
            this.$store.commit('removeTodo', i)
            this.sync()
        },
        toggleDone(id) {
            console.log(`Toggling for ${id}`)
            this.$store.commit('toggleDone', id)
            this.sync()
        },
        addTodo() {
            console.log(`Adding todo ${this.input}`)
            this.pushTodo({ name: this.input, done: false })
            this.input = ''
            this.sync()
        },
        async fetchAll() {
            // fetch All from remote
            let remote_todos
            let nam = this.todosArray.map(t => t.name) // local todos
            console.log(`local todos: ${nam}`)

            console.log(`fetching data for ${this.unam}`)

            await this.http.post('/getall/', { unam: this.unam }).then(response => {
                remote_todos = response.data
            }).catch(handleError)


            for (let r of remote_todos) {
                console.log(`Got remote item {name:${r.name}, done:${r.done}, ddl: ${r.ddl}}`)
                if (!nam.includes(r.name)) {
                    console.log(`\tAdding this`)
                    let ddl = r.ddl ? new Date(r.ddl) : undefined
                    this.pushTodo(makeTodo(r.name, r.done, ddl))
                }
            }
        },

        async sync() {
            /* await this.testOnline() */

            if (this.onlineCondition) {
                console.log('sync called online:')
                await this._sync()
            } else {
                console.log('sync called offline:')
            }
        },

        async _sync() {
            console.log('_sync() called')
            // Implementation 1:

            // delete all in remote
            await this.http.delete('/', { data: { unam: this.unam } })
                .catch(handleError)

            // Upload the local ones
            let todos = this.todosArray.map(todo => {
                return { name: todo.name, done: todo.done, ddl: todo.ddlString }
            })

            let a = { unam: this.unam, todos }
            console.log(`the todos to post ${JSON.stringify(a)}`)
            await this.http.post('/postmany/', a).catch(handleError)
        },
        logOut() {
            this.$store.commit('setUnam', '')
            this.clearTodos()
        },

        pushTodo(todo) { this.$store.commit('pushTodo', todo) },

        clearTodos() { this.$store.commit('clearTodos') },
        nextLang() { this.$store.commit('nextLang') },
        d(s) { return this.dict[s][this.lang] }
    },

    computed: {
        /* these are automatically readonly */
        unam() {
            return this.$store.state.unam
            /* return 'bbb' */
        },
        online() {
            return this.$store.state.online
        },
        todos() {
            return this.$store.state.todos
        },

        todosArray() {
            return this.$store.getters.todosArray
        },
        lang() {
            return this.$store.getters.lang
        },
        onlineCondition() {
            return this.$store.getters.onlineCondition
        }
    }
}


</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.todo-fade-enter-active,
.todo-fade-leave-active {
    transition: all 0.5s ease;
}

.todo-fade-enter-from {
    opacity: 0;
    transform: translateX(-30px);
}

.todo-fade-leave-to {
    opacity: 0;
    transform: translateX(30px);
}

.fade-enter-active,
.fade-leave-active {
    transition: 0.5s;
}

.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}
</style>
