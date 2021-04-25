<template>
  <div class="replies">
    <comment
      :key="key"
      v-for="(comment, key) in replies"
      :comment="comment"
    ></comment>
  </div>
</template>

<script>
import Comment from "./Comment"

export default {
  name: "Replies",
  components: {
    Comment
  },
  props: {
    replies: {
      type: Array,
      default: () => []
    }
  }
}
</script>

<style lang="scss">
  .replies {
    padding-left: 50px;
  }
</style>
