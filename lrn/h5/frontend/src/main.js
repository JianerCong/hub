//import "bootstrap/dist/css/bootstrap.min.css"
import 'bootswatch/dist/darkly/bootstrap.min.css'; // Added this :boom:
import "bootstrap"
import "bootstrap-icons/font/bootstrap-icons.css"
import './assets/usefont.css'


import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'


document.documentElement.lang = store.getters.lang
createApp(App).use(store).use(router).mount('#app')
