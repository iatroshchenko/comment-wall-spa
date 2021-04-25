import {client} from "../../../axios";

/* Getters */
import {
} from "./getters";

/* Actions */
import {
  COMMENTS_ACTION_FETCH_COMMENTS
} from "./actions";

/* Mutations */
import {
} from "./mutations";

const state = {
};
const getters = {
};
const actions = {
  [COMMENTS_ACTION_FETCH_COMMENTS]: (context) => {
    return client.get(route('internal.comments.all'))
  }
};
const mutations = {
};

export default {
  namespaced: 'true',
  state,
  getters,
  actions,
  mutations
}
