<template>
  <router-link
    :class="classValue"
    :to="to"
  >
    <slot></slot>
  </router-link>
</template>

<script>
export default {
  name: "Link",
  props: {
    current: {
      type: Boolean,
      default: false
    },
    mobile: {
      type: Boolean,
      default: false
    },
    to: {
      type: String
    }
  },
  data() {
    return {
    }
  },
  computed: {
    classValue() {
      if (this.mobile) {
        return this.current ?
          'bg-indigo-50 border-indigo-500 text-indigo-700 block pl-3 pr-4 py-2 border-l-4 text-base font-medium' :
          'border-transparent text-gray-600 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-800 block pl-3 pr-4 py-2 border-l-4 text-base font-medium'
      }

      return this.current ?
        'border-indigo-500 text-gray-900 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium' :
        'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium'
    }
  }
}
</script>

<style scoped>

</style>
