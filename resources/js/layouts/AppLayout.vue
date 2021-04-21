<template>
  <div class="bg-gray-100">

    <div class="min-h-screen bg-white">
      <Navbar></Navbar>
      <router-view></router-view>
    </div>

  </div>
</template>

<script>
import Navbar from "../components/nav/Navbar";

export default {
  name: "AppLayout",
  components: {
    Navbar
  }
}
</script>

<style scoped>

</style>
