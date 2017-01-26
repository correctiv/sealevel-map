'use strict'

if (module.hot) {
  module.hot.accept()
}

import { mount } from 'riot'
import stations from '../data/subset.json'
import '../styles/index.scss'
import './components/sealevel-app.tag'
import './components/sealevel-map.tag'
import './components/sealevel-details.tag'
import './components/sealevel-linechart.tag'
import './components/sealevel-navigation.tag'

mount('sealevel-app', {
  items: stations,
  center: [41.890251, 12.492373],
  zoom: 2,
  overlayOptions: {
    barWidth: 2,
    maxHeight: 300
  },
  tiles: 'https://api.mapbox.com/styles/v1/felixmichel/ciy1kvtfs00cn2sn05vsxk0g2/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZmVsaXhtaWNoZWwiLCJhIjoiZWZrazRjOCJ9.62fkOEqGMxFxJZPJuo2iIQ',
  attribution: 'CartoDB <a href="https://cartodb.com/attributions">attribution</a>'
})
