<template>
  <div class="comment">
    <div class="relative flex items-start space-x-3">
      <div class="relative">
        <img
          src="https://images.unsplash.com/photo-1520785643438-5bf77931f493?ixlib=rb-=eyJhcHBfaWQiOjEyMDd9&amp;auto=format&amp;fit=facearea&amp;facepad=8&amp;w=256&amp;h=256&amp;q=80"
          alt=""
          class="h-10 w-10 rounded-full bg-gray-400 flex items-center justify-center ring-8 ring-white"
        >
        <span class="absolute -bottom-0.5 -right-1 bg-white rounded-tl px-0.5 py-px">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" class="h-5 w-5 text-gray-400">
            <path fill-rule="evenodd" d="M18 5v8a2 2 0 01-2 2h-5l-5 4v-4H4a2 2 0 01-2-2V5a2 2 0 012-2h12a2 2 0 012 2zM7 8H5v2h2V8zm2 0h2v2H9V8zm6 0h-2v2h2V8z" clip-rule="evenodd"></path>
          </svg>
        </span>
      </div>
      <div class="min-w-0 flex-1">
        <div>
          <div class="text-sm">
            <a class="font-medium text-gray-900">
              {{ comment.name }}
            </a>
          </div>
          <p class="mt-0.5 text-sm text-gray-500">
            Commented {{ comment.when }}
            <a @click="onReplyClick" class="ml-2 font-medium text-gray-900 cursor-pointer">
              Reply
            </a>
          </p>
        </div>
        <div class="mt-2 text-sm text-gray-700">
          <p>
            {{ comment.body }}
          </p>
        </div>
      </div>
    </div>

    <Replies
      :replies="comment.replies"
    ></Replies>
  </div>
</template>

<script>

import {mapActions} from "vuex";
import {COMMENTS_ACTION_SELECT_COMMENT} from "../../store/modules/comments/actions";

export default {
  name: "Comment",
  components: {
    Replies: () => import('./Replies')
  },
  props: {
    comment: {
      type: Object,
      default: () => {}
    }
  },
  methods: {
    ...mapActions({
      selectComment: 'comments/' + COMMENTS_ACTION_SELECT_COMMENT
    }),
    onReplyClick() {
      this.selectComment(this.comment)
    }
  }
}
</script>

<style scoped>

</style>
