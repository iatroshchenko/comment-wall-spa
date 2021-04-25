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

        <div id="comment-field" class="relative p-8">
          <div class="px-4 bg-white">
            <div>
              <label for="reply" class="block text-sm font-medium text-gray-700">
                Comment
              </label>
              <div class="mt-1">
              <textarea
                id="reply" name="about" rows="3"
                class="p-2 shadow-sm focus:ring-indigo-500 focus:border-indigo-500 mt-1 block w-full sm:text-sm border-gray-300 rounded-md"
                placeholder="Type something ..."
              />
              </div>
              <p class="mt-2 text-sm text-gray-500">
                Write your comment or reply
              </p>
            </div>
          </div>
          <div class="px-4 py-3 bg-gray-50 text-right sm:px-6">
            <a class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              Comment
            </a>
          </div>
        </div>

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
import {COMMENTS_ACTION_FETCH_COMMENTS} from "../../store/modules/comments/actions";
import Comment from "../comments/Comment";

export default {
  name: "Index",
  middleware: ['auth'],
  components: {
    Comment
  },
  computed: {
    ...mapGetters({
      user: 'auth/' + AUTH_GET_USER
    })
  },
  data () {
    return {
      comments: []
    }
  },
  methods: {
    ...mapActions({
      fetchComments: 'comments/' + COMMENTS_ACTION_FETCH_COMMENTS
    }),
    loadComments() {
      this.fetchComments()
        .then(res => {
          this.comments = [...res.data.data]
        })
    }
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
