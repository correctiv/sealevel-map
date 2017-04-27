import L from 'leaflet'
import * as d3 from 'd3'

const MIN_YEAR = 1985
const MAX_YEAR = 2014

const DOMAIN = [-100, 100]

const MARKER_OPTIONS = {
  className: 'circle-marker',
  iconSize: 10
}

const CATEGORIES = [
  'circle-marker--lower',
  'circle-marker--low',
  'circle-marker--neutral',
  'circle-marker--high',
  'circle-marker--higher'
]

const ANIMATION = 'circle-marker--blink'

const findTide = ({ tideData }, year) => {
  let tideItem = tideData.find(item => item.year === year)
  return tideItem && tideItem.tide
}

const createMarkers = (stations, clickCallback) => {
  return stations.map(station => {
    const latLng = [station.latitude, station.longitude]
    const circleIcon = L.divIcon(MARKER_OPTIONS)
    const marker = L.marker(latLng, {
      icon: circleIcon,
      maxValue: 0
    })

    marker.on('click', event => clickCallback(station.ID))
    return marker
  })
}

const triggerMarkerAnimation = (element) => {
  element.addEventListener('animationend', () => {
    element.classList.remove(ANIMATION)
  })

  element.classList.add(ANIMATION)
}

const ExplorerLayer = L.LayerGroup.extend({

  initialize: function ({ stations, clickCallback, isAnimated }) {
    let scale = d3.scaleQuantize().domain(DOMAIN).range(CATEGORIES)

    this._stations = stations
    this._circleMarkers = createMarkers(stations, clickCallback)

    if (isAnimated) {
      this._initializeAnimation(scale)
    } else {
      this._redraw(MAX_YEAR, scale)
    }

    L.LayerGroup.prototype.initialize.call(this, this._circleMarkers)
  },

  onRemove: function (map) {
    clearInterval(this._animationLoop)
    L.LayerGroup.prototype.onRemove.call(this, map)
  },

  _initializeAnimation: function (scale) {
    let year = MIN_YEAR

    // Initialize animation loop:
    this._animationLoop = setInterval(() => {
      this._redraw(year++, scale)
      if (year > MAX_YEAR) clearInterval(this._animationLoop)
    }, 1000)
  },

  _redraw: function (year, scale) {
    this._circleMarkers.forEach((marker, i) => {
      const tide = findTide(this._stations[i], year)
      const element = marker.getElement()
      const categoryClassName = scale(tide)

      // Remove old categories:
      CATEGORIES.forEach(className => {
        element.classList.remove(className)
      })

      // Apply new category:
      element.classList.add(categoryClassName)

      // Trigger animation for new maxima:
      if (tide > marker.options.maxValue) {
        marker.options.maxValue = tide
        triggerMarkerAnimation(element)
      }
    })
  }
})

export default (...args) => {
  return new ExplorerLayer(...args)
}
