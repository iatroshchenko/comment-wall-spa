import store from '../store'
import { AUTH_GET_USER } from '../store/modules/auth/getters'
import { AUTH_ACTION_UPDATE_USER } from '../store/modules/auth/actions'

export default async (to, from, next) => {
  // load initial state if page loaded first time
  if (!store.getters['auth/' + AUTH_GET_USER]) {
    await store.dispatch('auth/' + AUTH_ACTION_UPDATE_USER)
  }

  return next()
}
