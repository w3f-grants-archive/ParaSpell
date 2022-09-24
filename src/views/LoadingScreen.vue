<template>
  <b-field style="margin-top:25%"  class="textt" label="Please wait while application is setting up for first time."></b-field>
</template>

<script lang="ts">
  import { defineComponent } from '@vue/composition-api'

  export default defineComponent({
    mounted: async function () {
    //You can add anything here you wish to load before application starts
    setTimeout( () => this.$router.push({ path: '/home'}));
    }
  })
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@200&display=swap');
.textt{
  color: black;
  font-family: 'Poppins', sans-serif;
  font-size: 30px;
  margin-top: 30px;
}
</style>