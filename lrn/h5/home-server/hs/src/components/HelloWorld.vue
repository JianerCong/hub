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
                <i class="bi bi-upload"></i>
            </button>
        </div>
    </nav>

    <div id="" style="height: 70px;"> </div>

    
    <div class="container" v-if="simple_display">
        <div class="card mt-1 flex-row " v-for="file in files" :key="file.name">
            <div class="d-flex align-items-center w-100 fs-6 m-1">
                <span v-if="file.is_folder">
                    <i class="bi bi-folder"></i>
                </span>
                <span v-else>
                    <i class="bi bi-file-earmark"></i>
                </span>
                <span class="ms-2">
                    {{ file.name }}
                </span>
            </div>
            <div class="d-flex align-items-center justify-content">
                <i class="bi bi-backspace m-1 me-2"></i>
                <!-- <a href="#" class="btn btn-outline-primary m-1 btn-sm">
                     </a> -->
            </div>
        </div>
    </div>
    <div class="container d-flex" v-else>
        
    </div>




  <!-- 看这里 -->
</template>

<style scoped>
</style>
