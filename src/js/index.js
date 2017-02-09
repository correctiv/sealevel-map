'use strict'

if (module.hot) {
  module.hot.accept()
}

import riot from 'riot'
import thunk from 'redux-thunk'
import { createStore, applyMiddleware } from 'redux'

import '../styles/index.scss'

import { SHOW_STATION_DETAILS, HIDE_STATION_DETAILS, EXPLORER_DATA_LOADED } from './actions'
import './components/sealevel-app.tag'
import './components/sealevel-map.tag'
import './components/sealevel-details.tag'
import './components/sealevel-linechart.tag'
import './components/sealevel-navigation.tag'

const initialState = {
  currentStation: null,
  explorerData: []
}

const findStation = (data, id) => {
  return data.find(({ID}) => ID.toString() === id.toString())
}

const reducer = (state = initialState, action) => {
  console.log(action)

  switch (action.type) {
    case EXPLORER_DATA_LOADED:
      return { ...state, explorerData: action.data.stations }

    case SHOW_STATION_DETAILS:
      return { ...state, currentStation: findStation(state.explorerData, action.id) }

    case HIDE_STATION_DETAILS:
      return { ...state, currentStation: null }

    default:
      return state
  }
}

const thunkMiddleware = applyMiddleware(thunk)
const store = createStore(reducer, thunkMiddleware)

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
