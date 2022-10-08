<template>
    <div>
        <!-- The nav bar -->
        <nav class="navbar navbar-expand-lg bg-secondary navbar-dark py-3 fixed-top">
            <div class="container">
                <a href="#" class="navbar-brand">{{d('log_in')}}</a>
            </div>
        </nav>

        <!-- the log in page -->
        <section>
            <div class="container pt-4">

                <div class="input-group mb-3">
                    <span class="input-group-text" ><i class="bi bi-person-circle"></i></span>
                    <input type="text" class="form-control"
                           v-model="unam" :class="{ 'is-invalid': unamWrong }"
                    >
                </div>
                <div class="input-group mb-3">
                    <span class="input-group-text" ><i class="bi bi-lock-fill"></i></span>
                    <input type="password" class="form-control"
                           v-model="pswd" :class="{ 'is-invalid': pswdWrong}"
                    >
                </div>

                <!-- the messages -->

                <div v-show="unamWrong" class="alert alert-danger" role="alert">
                    {{d('unam_empty')}}
                </div>
                <div v-show="pswdWrong" class="alert alert-danger" role="alert">
                    {{d('pswd_empty')}}
                </div>

                <div v-show="msg !== ''" class="alert alert-danger" role="alert">
                    {{msg}}
                </div>

                <!-- the submit buttons -->
                <div class="d-grid gap-2 mt-3 mx-auto d-md-flex justify-content-md-end"
                     style="grid-template-columns: repeat(3, 1fr);"
                >
                    <button class="btn btn-info my-login-btn my-min-width" type="button" @click="toSignUp">
                            {{d('sign_up')}}
                    </button>
                    <button class="btn btn-success my-login-btn my-min-width" type="button" @click="send">
                        <span class="h3">
                            <i class="bi bi-check"></i>
                        </span>
                    </button>
                    <button class="btn btn-secondary my-login-btn my-min-width" type="button" @click="toHome">
                        <span class="h3">
                                <i class="bi bi-x"></i>
                        </span>
                    </button>
                </div>

            </div>
        </section>

        <!-- the spinner -->
        <section v-show="loading">
            <div class="container">
                <div class="d-flex justify-content-center">
                    <div class="spinner-border m-5" role="status" style="width: 3rem; height: 3rem;">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
            </div>
        </section>

    </div>
</template>

<script>
 import f from './common_for_login_signup.js'
 import {handleError} from './funcs.js'
 export default {
     setup(){
         const dict =  {
             log_in: {en: 'Log In', zh: '登录'},
             server_down: {en: 'Server down', zh: '服务器不在'},
             unam_empty: {en: 'Username empty', zh: '没给用户名'},
             pswd_empty: {en: 'Password empty', zh: '没给密码'},
             sign_up: {en: 'Sign Up', zh:'注册'},
         }

         const {http, toHome, unam,pswd,
          unamWrong, pswdWrong, online, lang} = f()

         function d(key) {
            const s = dict[key][lang.value]
            // console.log(`d called with ${key}, lang=${lang.value}, val=${s}`)
            return s
        }

         return {dict, http, toHome,unam, pswd,
                 unamWrong, pswdWrong,online,lang,d
         }
     },
     data() {
         return {
             loading: false,
             msg: '',
         }
     },
     created: function(){
         console.log(`Login created() called with BACKEND = ${this.http.getUri()} `)
     },
     methods: {
         toSignUp() {
             this.$router.push({path: '/signup'})
         },

         async send() {
             if (this.unamWrong) {
                 return;/* empty username */
             }
             if (this.pswdWrong) {
                 return;/* empty password */
             }

             console.log(`Try logging in  as (${this.unam}, ${this.pswd}, ${this.lang})`)
             this.loading = true

             let data
             if (this.online) {
                 await this.http.post('login/',
                                      {unam: this.unam,
                                       pswd: this.pswd,
                                       lang: this.lang,
                 }).then( res => {
                     data = res.data
                 }).catch(handleError)
                 this.loading = false
                 if (data.ok) {
                     console.log(`login okay with ${this.unam}`)
                     this.$store.commit('setUnam', this.unam)
                     this.$router.push({path: '/'})
                 } else {
                     console.log(`login failed with ${this.unam}`)
                     this.msg = data.msg
                 }
             } else {
                 if (process.env.NODE_ENV === 'production') {
                     let s = this.d('server_down')
                     console.log(s)
                     this.msg = s
                     this.loading = false
                 } else {
                     console.log(`Not online, doing a fake log in`)
                     //a wait for 3 sec
                     setTimeout(()=> {
                         this.loading = false
                         console.log(`done`)
                         this.$store.commit('setUnam',this.unam)
                         this.$router.push({path: '/'})
                     },3000)
                 }
             }
         },
     },
 }

</script>
