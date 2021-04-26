import {client} from "../../../axios";

/* Getters */
import {
  COMMENTS_GET_SELECTED,
  COMMENTS_GET_COMMENTS
} from "./getters";

/* Actions */
import {
  COMMENTS_ACTION_FETCH_COMMENTS, COMMENTS_ACTION_LOAD_COMMENTS,
  COMMENTS_ACTION_SELECT_COMMENT,
  COMMENTS_ACTION_SUBMIT_COMMENT
} from "./actions";

/* Mutations */
import {
  COMMENTS_MUTATION_SET_SELECTED,
  COMMENTS_MUTATION_SET_COMMENTS
} from "./mutations";

const state = {
  comments: [],
  selectedComment: null
};
const getters = {
  [COMMENTS_GET_SELECTED]: state => state.selectedComment,
  [COMMENTS_GET_COMMENTS]: state => state.comments
};
const actions = {
  [COMMENTS_ACTION_FETCH_COMMENTS]: (context) => {
    return client.get(route('internal.comments.all'))
  },
  [COMMENTS_ACTION_LOAD_COMMENTS]: async (context) => {
    const response = await context.dispatch(COMMENTS_ACTION_FETCH_COMMENTS);
    const comments = response.data.data;
    context.commit(COMMENTS_MUTATION_SET_COMMENTS, comments);
    return comments;
  },
  [COMMENTS_ACTION_SELECT_COMMENT]: (context, payload) => {
    context.commit(COMMENTS_MUTATION_SET_SELECTED, payload)
  },
  [COMMENTS_ACTION_SUBMIT_COMMENT]: (context, payload) => {
    return client.post(route('internal.comments.submit'), {
      ...payload,
      reply_to: context.state.selectedComment ? context.state.selectedComment.id : null
    })
  }
};
const mutations = {
  [COMMENTS_MUTATION_SET_SELECTED]: (state, payload) => {
    state.selectedComment = payload
  },
  [COMMENTS_MUTATION_SET_COMMENTS]: (state, payload) => {
    state.comments = payload
  }
};

export default {
  namespaced: 'true',
  state,
  getters,
  actions,
  mutations
}
