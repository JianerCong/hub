<template>
    <div class="hello">
        <div class="form-check form-switch text-center">
            <input class="form-check-input" type="checkbox" id="flexSwitchCheckDefault" v-model="x">
            <!-- <label class="form-check-label" for="flexSwitchCheckDefault">Default switch checkbox input</label> -->
        </div>
        <div>
            <span class="badge bg-primary" @click="switchToDark">Switch To Dark</span>
            <span class="badge bg-secondary" @click="removeDark">Remove Dark</span>
            <span class="badge bg-success">Success</span>
            <span class="badge bg-danger">Danger</span>
            <span class="badge bg-warning text-dark">Warning</span>
            <span class="badge bg-info text-dark">Info</span>
            <span class="badge bg-light text-dark">Light</span>
            <span class="badge bg-dark">Dark</span>
        </div>
    </div>
</template>

<script>
 export default {
     name: 'HelloWorld',
     props: {
         msg: String
     },
     data() {
         return {
             x: false,
             cssHref: 'darkly2/bootstrap.min.css'/* need to have this in the `public` folder */
         }
     },
     watch: {
         x(oldX,newX){
             if (!newX) this.switchToDark()
             else this.removeDark()
},
     },
     methods: {
         f() {
             console.log(`now x is ${this.x}`)
         },

         switchToDark() {
             console.log('Switching to dark')
             let cssNode = document.createElement('link')
             cssNode.type = 'text/css'
             cssNode.rel = 'stylesheet'
             cssNode.media = 'screen'

             let head = document.getElementsByTagName('head')[0]
             cssNode.href = this.cssHref
             head.appendChild(cssNode)
         },

         removeDark() {
             console.log('removing dark')
             let allLinks = document.getElementsByTagName('link')
             for (let link of allLinks) {
                 let href = link.getAttribute('href')
                 if (href && href.includes(this.cssHref)) {
                     link.parentNode.removeChild(link)
                 }
             }
         }
     }
 }
</script>

