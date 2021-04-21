<template>
  <div class="app">
    <component :is="layout" v-if="layout" />
  </div>
</template>

<script>
import Navbar from "./nav/Navbar"
import AppLayout from "../layouts/AppLayout";
import { client } from "../axios"

// Load layout components dynamically.
const requireContext = require.context('../layouts', false, /.*\.vue$/)

const layouts = requireContext.keys()
  .map(file =>
    [file.replace(/(^.\/)|(\.vue$)/g, ''), requireContext(file)]
  )
  .reduce((components, [name, component]) => {
    components[name] = component.default || component
    return components
  }, {})

export default {
  name: "App",
  components: {
    Navbar,
    AppLayout
  },
  data() {
    return {
      layout: null,
      defaultLayout: AppLayout.name
    }
  },
  created() {
    client
      .get('/sanctum/csrf-cookie')
      .then(response => {
        console.log('CSRF Cookie received')
      });
  },
  methods: {
    setLayout(layout) {
      if (!layout || !layouts[layout]) {
        layout = this.defaultLayout
      }

      this.layout = layouts[layout]
    }
  }
}
</script>

<style scoped>

</style>
