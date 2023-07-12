if (module.hot) {
  module.hot.accept()
}

import riot from 'riot'
import route from 'riot-route'
import thunk from 'redux-thunk'
import { createStore, applyMiddleware } from 'redux'
import riotReduxMixin from 'riot-redux-mixin'
import reducer from './reducers'
import i18n from './mixins/i18n'

import '../styles/index.scss'
import './components/app.tag'

// Set base path for router
route.base('/')

// Initialize redux store
const store = createStore(reducer, applyMiddleware(thunk))
riot.mixin(riotReduxMixin(store))

// Initialize i18n mixin
riot.mixin(i18n('de'))

// Mount root tag
riot.mount('sealevel-app')
