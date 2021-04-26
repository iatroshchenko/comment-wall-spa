<template>
  <div id="comment-field" class="relative p-8">
    <div class="comment-to-reply bg-yellow-100"
         v-show="commentToReply"
    >
      <div class="px-4 py-3 sm:px-6 flex justify-between items-center">
        <div>
          Replying to comment
        </div>
        <a
          @click="onCancelClick"
          class="cursor-pointer inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
          Cancel
        </a>
      </div>
      <div class="px-4 py-3 bg-gray-50 sm:px-6 mb-2">
        {{ commentToReply }}
      </div>
    </div>

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
                v-model="comment.body"
              />
        </div>
        <p class="mt-2 text-sm text-gray-500">
          Write your comment or reply
        </p>
      </div>
    </div>

    <div class="px-4 py-3 bg-gray-50 text-right sm:px-6">
      <a
        @click="onCommentSubmitClick"
        class="cursor-pointer inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
        Comment
      </a>
    </div>
  </div>
</template>

<script>
import {mapActions, mapGetters} from "vuex";
import {COMMENTS_GET_SELECTED} from "../../store/modules/comments/getters";
import {
  COMMENTS_ACTION_LOAD_COMMENTS,
  COMMENTS_ACTION_SELECT_COMMENT,
  COMMENTS_ACTION_SUBMIT_COMMENT
} from "../../store/modules/comments/actions";

export default {
  name: "CommentField",
  data() {
    return {
      comment: {
        body: ''
      }
    }
  },
  methods: {
    ...mapActions({
      selectComment: 'comments/' + COMMENTS_ACTION_SELECT_COMMENT,
      submitComment: 'comments/' + COMMENTS_ACTION_SUBMIT_COMMENT,
      loadComments: 'comments/' + COMMENTS_ACTION_LOAD_COMMENTS
    }),
    onCancelClick() {
      this.selectComment(null)
    },
    onCommentSubmitClick() {
      this.submitComment({
        ...this.comment
      })
        .then(res => {
          this.comment.body = '';
          this.loadComments()
        })
    }
  },
  computed: {
    ...mapGetters({
      commentToReply: 'comments/' + COMMENTS_GET_SELECTED
    })
  }
}
</script>

<style scoped>

</style>
