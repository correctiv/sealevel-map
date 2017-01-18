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
  tiles: 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_nolabels/{z}/{x}/{y}@2x.png',
  attribution: 'CartoDB <a href="https://cartodb.com/attributions">attribution</a>'
})
