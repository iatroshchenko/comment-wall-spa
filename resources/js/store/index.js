// State Management
import Vue from 'vue'
import Vuex from 'vuex'

// Modules
import auth from "./modules/auth/auth"

Vue.use(Vuex);

const store = new Vuex.Store({
  modules: {
    auth
  }
});

export default store;
