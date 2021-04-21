import store from '../store'
import { AUTH_GET_AUTHENTICATED } from '../store/modules/auth/getters'

export default async (to, from, next) => {
  const user = store.getters['auth/' + AUTH_GET_AUTHENTICATED]

  if (user) {
    next('/')
  }

  next()
}
