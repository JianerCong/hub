<template>
    <!-- <nav>
         <router-link to="/">Home</router-link> |
         <router-link to="/about">About</router-link>
         </nav> -->
  <router-view/>
</template>

<style>

 .my-min-width {
     min-width: 110px;
 }

 /* add space for the nav bar */
 body::before {
     display: block;
     content: "";
     height: 80px;
 }

/* Add the following so that the router-link dosen't look like a hyperlink */

 /* a {
    color: black !important; 
    text-decoration: none !important;
    } */
</style>
