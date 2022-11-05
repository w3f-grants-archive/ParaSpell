import Vue from 'vue'
import VueRouter, { RouteConfig } from 'vue-router'
import HomeView from '../views/HomeView.vue'

Vue.use(VueRouter)

const routes: Array<RouteConfig> = [
  {
    path: '/',
    name: 'loadingScreen',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../views/LoadingScreen.vue')
  },
  {
    path: '/paratorelay',
    name: 'paratorelay',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../views/ParaToRelay.vue')
  },
  {
    path: '/relaytopara',
    name: 'relaytopara',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../views/RelayToPara.vue')
  },
  {
    path: '/paratopara',
    name: 'paratopara',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../views/ParaToPara.vue')
  },
  {
    path: '/home',
    name: 'home',
    component: HomeView
  },
  {
    path: '/closechannel',
    name: 'closeChannel',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../views/CloseChannel.vue')
  },
  {
    path: '/openchannel',
    name: 'openChannel',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../views/OpenChannel.vue')
  },

]

const router = new VueRouter({
  base: process.env.BASE_URL,
  routes
})

export default router
