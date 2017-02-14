'use strict'

if (module.hot) {
  module.hot.accept()
}

import riot from 'riot'
import thunk from 'redux-thunk'
import { createStore, applyMiddleware } from 'redux'

import reducer from './reducers'

import '../styles/index.scss'
import './components/sealevel-app.tag'
import './components/sealevel-map.tag'
import './components/sealevel-details.tag'
import './components/sealevel-linechart.tag'
import './components/sealevel-navigation.tag'
import './components/sealevel-explorer-overview.tag'

const store = createStore(reducer, applyMiddleware(thunk))

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
