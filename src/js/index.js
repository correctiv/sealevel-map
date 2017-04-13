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
import './components/map.tag'
import './components/navigation.tag'

// Set base path for router
route.base('/')

// Initialize redux store
const store = createStore(reducer, applyMiddleware(thunk))
riot.mixin(riotReduxMixin(store))

// Initialize i18n mixin
riot.mixin(i18n('de'))

// Mount root tag
riot.mount('sealevel-app', {
  store: store,
  center: [41.890251, 12.492373],
  zoom: 2,
  overlayOptions: {
    barWidth: 2,
    maxHeight: 300
  },
  tiles: 'https://api.mapbox.com/styles/v1/felixmichel/ciy1kvtfs00cn2sn05vsxk0g2/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZmVsaXhtaWNoZWwiLCJhIjoiZWZrazRjOCJ9.62fkOEqGMxFxJZPJuo2iIQ',
  attribution: 'CartoDB <a href="https://cartodb.com/attributions">attribution</a>'
})
