/*
* Naming convention:
*
* Getters:
* [MODULE]_GET_[The thing You Get]
*
* Actions/Mutations
* [MODULE]_[ACTION/MUTATION]_[Action Name]
*
* */

import { client } from '../../../axios'

/* Getters */
import {
  AUTH_GET_USER
} from "./getters"

/* Actions */
import {
  AUTH_ACTION_UPDATE_USER,
  AUTH_ACTION_ATTEMPT_LOGIN,
  AUTH_ACTION_LOGOUT,
  AUTH_ACTION_REGISTER
} from "./actions"

/* Mutations */
import {
  AUTH_MUTATION_SET_USER,
  AUTH_MUTATION_SET_AUTHENTICATED
} from "./mutations"

const state = {
  user: null,
  authenticated: false
}

const getters = {
  [AUTH_GET_USER]: state => state.user
}

const actions = {
  async [AUTH_ACTION_UPDATE_USER] (context, payload) {
    try {
      const userInfoRoute = route('internal.userinfo')
      const response = await client.get(userInfoRoute)
      const user = response.data.data

      context.commit(AUTH_MUTATION_SET_USER, user)
      const authenticated = user ? true : false
      context.commit(AUTH_MUTATION_SET_AUTHENTICATED, authenticated)
    } catch(e) {
      console.log(e)
    }

    return true
  },
  [AUTH_ACTION_ATTEMPT_LOGIN] (context, payload) {
    const loginRoute = route('login')
    return client.post(loginRoute, {
      ...payload
    })
  },
  [AUTH_ACTION_REGISTER] (context, payload) {
    const registerRoute = route('register')
    return client.post(registerRoute, {
      ...payload
    })
  },
  async [AUTH_ACTION_LOGOUT] (context, payload) {
    const logoutRoute = route('logout')
    await client.post(logoutRoute)
    context.commit(AUTH_MUTATION_SET_AUTHENTICATED, false)
    return true
  }
}

const mutations = {
  [AUTH_MUTATION_SET_USER] (state, user) {
    state.user = user ? {...user} : null
  },
  [AUTH_MUTATION_SET_AUTHENTICATED] (state, authenticated) {
    state.authenticated = authenticated
  }
}

export default {
  namespaced: 'true',
  state,
  getters,
  actions,
  mutations
}
