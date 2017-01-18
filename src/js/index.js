'use strict'

if (module.hot) {
  module.hot.accept()
}

import { mount } from 'riot'
import stations from '../data/subset.json'
import '../styles/index.scss'
import './components/sealevel-map.tag'
import './components/sealevel-app.tag'
import './components/sealevel-details.tag'
import './components/sealevel-linechart.tag'

mount('sealevel-app', {
  items: stations,
  center: [41.890251, 12.492373],
  zoom: 2,
  overlayOptions: {
    barWidth: 2,
    maxHeight: 300
  },
  tiles: 'https://api.mapbox.com/styles/v1/felixmichel/ciy1l1oag00dx2sl5tbia4zr1/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZmVsaXhtaWNoZWwiLCJhIjoiZWZrazRjOCJ9.62fkOEqGMxFxJZPJuo2iIQ',
  attribution: 'CartoDB <a href="https://cartodb.com/attributions">attribution</a>'
})
