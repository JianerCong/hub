<template>
        <div class="about">
            <!-- The nav bar -->
            <nav class="navbar navbar-expand-lg bg-secondary navbar-dark py-3 fixed-top">
                <div class="container ">
                    <a href="#" class="navbar-brand px-4 px-md-0">{{d('about')}}</a>
                    <button type="button" class="btn-close pe-2 pe-md-0" @click="toHome"></button>
                </div>

            </nav>


            <!-- the log in page -->
            <section>
                <div class="accordion p-3 px-lg-5" id="accordionPanelsStayOpenExample">
                    <div class="accordion-item">
                      <h2 class="accordion-header" id="panelsStayOpen-headingOne">
                        <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseOne" aria-expanded="true" aria-controls="panelsStayOpen-collapseOne">
                          {{d('fmwk')}}
                        </button>
                      </h2>
                      <div id="panelsStayOpen-collapseOne" class="accordion-collapse collapse show" aria-labelledby="panelsStayOpen-headingOne">
                        <div class="accordion-body">
                            <div class="list-group">
  <a href="https://vuejs.org/" class="list-group-item list-group-item-action" aria-current="true">Vue 3</a>
  <a href="https://getbootstrap.com/" class="list-group-item list-group-item-action">Bootstrap 5</a>
</div>
                        </div>
                      </div>
                    </div>
                    <div class="accordion-item">
                      <h2 class="accordion-header" id="panelsStayOpen-headingTwo">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseTwo" aria-expanded="false" aria-controls="panelsStayOpen-collapseTwo">
                          {{d('cont_auth')}}
                        </button>
                      </h2>
                      <div id="panelsStayOpen-collapseTwo" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingTwo">
                        <div class="accordion-body">
Email: congjianer@outlook.com
                        </div>
                      </div>
                    </div>
                  </div>
            </section>

        </div>
</template>

<script>
  export default {

    data() {
         return {
             dict: {
              about: {en: 'About', zh:'关于'},
                 cont_auth: {en: 'Contact the author', zh: '找作者'},
                 fmwk: {en: 'What frameworks?', zh: '哪些包？'},
                },
}
  },
  methods: {
    toHome() {
             this.$router.push({path: '/'})
         },
    d (key) {
             return this.dict[key][this.lang]
         },
  },
  computed: {
         lang() {
             return this.$store?.getters.lang
         }
     }
  }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
@media (min-width: 1200px){
  .container {
    max-width: 1240px;
}
}
 </style>
 