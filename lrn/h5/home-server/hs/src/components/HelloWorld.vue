<script setup>
 /* In Single-File Components, `setup` is shorthand, meaning that all the code
 inside is wrapped in a setup() */

import { ref } from 'vue'

defineProps({
  msg: String,
})

const files = ref([
     {name: 'a.txt', is_folder: false},
     {name: 'b.txt', is_folder: false},
     {name: 'my-folder', is_folder: true},
])
const go_click = () => {
    console.log('go_click')
}

const current_folder = ref('/')

const simple_display = ref(true)
</script>


<template>

    <nav class="navbar
                fixed-top navbar-light bg-light">

        <div class="container-fluid">
            <a class="navbar-brand">
                <img src="/src/assets/dog1.svg" alt="" width="30" height="24" class="d-inline-block align-text-top">
                Current foler: {{ current_folder}}
            </a>
            <span class="nav-brand">
            </span>
            <div class="d-flex">
                <button type="button" class="btn
                              btn-outline-success"
                        @click="simple_display = !simple_display"
                >Toggle
                </button>
            </div>
        </div>
    </nav>

    <nav class="navbar fixed-bottom navbar-light bg-light">
        <div class="container-fluid">
            <input type="file" id="input" multiple />

            <button type="button" class="btn
                          btn-outline-success"
                    @click="go_click"
            >
                go
            </button>
        </div>
    </nav>

    <div id="" style="height: 70px;"> </div>

    <div class="container">
        <div class="card mt-1" v-for="file in files" :key="file.name">
            <div class="card-body">
                <span v-if="file.is_folder">📁</span>
                <span v-else>📄</span>
                {{ file.name }}
            </div>
        </div>
    </div>




  <!-- 看这里 -->
</template>

<style scoped>
</style>
