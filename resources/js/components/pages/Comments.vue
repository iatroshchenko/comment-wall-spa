<template>
  <div class="py-10">
    <header>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h1 class="text-3xl font-bold leading-tight text-gray-900">
          Comments
        </h1>
      </div>
    </header>
    <main>

      <div class="bg-white py-8 px-2">

        <comment-field></comment-field>

        <div class="relative p-8 max-w-lg">

          <Comment
            :key="key"
            v-for="(comment, key) in comments"
            :comment="comment"
          ></Comment>

        </div>

      </div>

    </main>
  </div>
</template>

<script>
import {mapActions, mapGetters} from 'vuex'
import {AUTH_GET_USER} from "../../store/modules/auth/getters";
import Comment from "../comments/Comment";
import CommentField from "../comments/CommentField";
import {COMMENTS_GET_COMMENTS} from "../../store/modules/comments/getters";
import {COMMENTS_ACTION_LOAD_COMMENTS} from "../../store/modules/comments/actions";

export default {
  name: "Index",
  middleware: ['auth'],
  components: {
    Comment,
    CommentField
  },
  computed: {
    ...mapGetters({
      user: 'auth/' + AUTH_GET_USER,
      comments: 'comments/' + COMMENTS_GET_COMMENTS
    })
  },
  data () {
    return {
    }
  },
  methods: {
    ...mapActions({
      loadComments: 'comments/' + COMMENTS_ACTION_LOAD_COMMENTS
    })
  },
  mounted() {
    this.loadComments()
  }
}
</script>

<style scoped>
  .replies {
    padding-left: 50px;
  }
</style>
