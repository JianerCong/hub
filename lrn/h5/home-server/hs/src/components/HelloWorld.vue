<script setup>
 /* In Single-File Components, `setup` is shorthand, meaning that all the code
 inside is wrapped in a setup() */

import { ref } from 'vue'

defineProps({
  msg: String,
})

const files = ref([
     {name: 'a.txt', is_folder: false},
     {name: 'b.pdf', is_folder: false},
     {name: 'c.mp3', is_folder: false},
     {name: 'd.doc', is_folder: false},
     {name: 'e.docx', is_folder: false},
     {name: 'f.mp4', is_folder: false},
     {name: 'g.c', is_folder: false},
     {name: 'h.cpp', is_folder: false},
     {name: 'i.R', is_folder: false},
     {name: 'j.tex', is_folder: false},
     {name: 'k.zip', is_folder: false},
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
                <span v-else-if="file.name.endsWith('pdf')">
                    <i class="bi bi-file-earmark-pdf"></i>
                </span>
                <span v-else-if="file.name.match(/(wav|mp3)$/i)">
                    <i class="bi bi-file-earmark-music"></i>
                </span>
                <span v-else-if="file.name.match(/\.(doc|docx)$/i)">
                    <i class="bi bi-file-earmark-word"></i>
                </span>
                <span v-else-if="file.name.match(/\.(ppt|pptx)$/i)">
                    <i class="bi bi-file-earmark-ppt"></i>
                </span>
                <!-- excel -->
                <span v-else-if="file.name.match(/\.(xsl)$/i)">
                    <i class="bi bi-file-earmark-spreadsheet"></i>
                </span>
                <span v-else-if="file.name.match(/\.(txt)$/i)">
                    <i class="bi bi-file-earmark-text"></i>
                </span>
                <span v-else-if="file.name.match(/\.(mp4)$/i)">
                    <i class="bi bi-file-earmark-play"></i>
                </span>
                <span v-else-if="file.name.match(/\.(zip|rar|gz|lz4)$/i)">
                    <i class="bi bi-file-earmark-zip"></i>
                </span>
                <span v-else-if="file.name.match(/\.(c|cpp|C|cxx|R|py|js|java|cs|go|tex|html|css|sass|scss|ts|md)$/i)">
                    <i class="bi bi-file-earmark-code"></i>
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
    <div class="container d-flex flex-wrap" v-else>
        <!-- The grid display -->
        <div class="card w-50" v-for="file in files" :key="file.name">
            <div class="d-flex justify-content-between">
                <div>
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
                <div>
                    <button type="button" class="btn-close" aria-label="Close"></button>
                </div>
            </div>
        </div>
    </div>

  <!-- 看这里 -->
</template>

<style scoped>
</style>
