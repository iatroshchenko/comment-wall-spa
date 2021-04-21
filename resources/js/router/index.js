import routes from "./routes"
import Router from 'vue-router'
import Vue from 'vue'

import {
  resolveMiddleware,
  scrollBehavior,
  resolveComponents,
  callMiddleware,
  getMiddlewareSequence
} from "./helpers"

Vue.use(Router)

// Middlewares which are applied for all components
const globalMiddlewareSequence = ['loadInitialState']

// Load middleware modules dynamically.
const middlewareCollection = resolveMiddleware(
  require.context('../middleware', false, /.*\.js$/)
)

const router = new Router({
  scrollBehavior: (to, from, savedPosition) => {
    scrollBehavior(router, to, from, savedPosition)
  },
  mode: 'history',
  routes
})

const beforeEach = async (to, from, next) => {
  let components = []

  try {
    // Get the matched components and resolve them.
    components = await resolveComponents(
      router.getMatchedComponents({ ...to })
    )
  } catch (error) {
    if (/^Loading( CSS)? chunk (\d)+ failed\./.test(error.message)) {
      window.location.reload(true)
      return
    }
  }

  if (components.length === 0) {
    return next()
  }

  // Get the middleware for all the matched components.
  const middlewareSequence = getMiddlewareSequence(components, globalMiddlewareSequence)

  // Call each middleware.
  callMiddleware(middlewareSequence, middlewareCollection, to, from, (...args) => {
    // Set the application layout only if "next()" was called with no args.
    if (args.length === 0) {
      router.app.setLayout(components[0].layout || '')
    }

    next(...args)
  })
}

/**
 * Global after hook.
 *
 * @param {Route} to
 * @param {Route} from
 * @param {Function} next
 */
async function afterEach (to, from, next) {
  // some logic here
}

router.beforeEach(beforeEach)
router.afterEach(afterEach)

export default router
