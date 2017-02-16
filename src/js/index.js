'use strict'

if (module.hot) {
  module.hot.accept()
}

import riot from 'riot'
import thunk from 'redux-thunk'
import { createStore, applyMiddleware } from 'redux'

import reducer from './reducers'

import '../styles/index.scss'
import './components/app.tag'
import './components/map.tag'
import './components/details.tag'
import './components/linechart.tag'
import './components/navigation.tag'
import './components/explorer-overview.tag'

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
