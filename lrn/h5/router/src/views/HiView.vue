<template>
  <div class="hi">
        <h1 @click="goBackHome" style="cursor: pointer;">Click Me to to back home in {{sec}} sec</h1>
  </div>
</template>

<script>
export default {
    name: 'HiView',
     data(){
         return {
             sec: 3
         }
     },
    methods: {
        goBackHome(){
             this.sec=3
            setTimeout(()=>{
                this.$router.push({path: '/'})
            },3000)
            
             setTimeout(()=>{
                 this.sec--
             },3000)

             setTimeout(()=>{
                 this.sec--
             },2000)


             setTimeout(()=>{
                 this.sec--
             },1000)
        }
    }
}
</script>
