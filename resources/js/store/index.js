// State Management
import Vue from 'vue'
import Vuex from 'vuex'

// Modules
import auth from "./modules/auth/auth"
import comments from "./modules/comments/сomments"

Vue.use(Vuex);

const store = new Vuex.Store({
  modules: {
    auth,
    comments
  }
});

export default store;
