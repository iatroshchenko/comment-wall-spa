import Index from "../components/pages/Index"
import About from "../components/pages/About"
import Login from "../components/pages/Login"
import Comments from "../components/pages/Comments"

const routes = [
  {
    path: '/',
    name: 'pages.index',
    component: Index
  },
  {
    path: '/about',
    name: 'pages.about',
    component: About
  },
  {
    path: '/login',
    name: 'pages.login',
    component: Login
  },
  {
    path: '/comments',
    name: 'pages.comments',
    component: Comments
  }
]

export default routes
