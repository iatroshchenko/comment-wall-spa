import store from '../store'
import { AUTH_GET_USER } from '../store/modules/auth/getters'

export default async (to, from, next) => {
  const user = store.getters['auth/' + AUTH_GET_USER]

  if (!user) {
    return next('/login')
  }

  return next()
}
