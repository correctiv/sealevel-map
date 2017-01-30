import L from 'leaflet'
import * as d3 from 'd3'

const MIN_YEAR = 1985
const MAX_YEAR = 2014

const COLORS = [
  '#132c6c',
  'rgba(87, 22, 58, 0)',
  '#9a0008'
]

const MARKER_OPTIONS = {
  stroke: true,
  weight: 1,
  radius: 3,
  fillOpacity: 0.7,
  color: COLORS[1],
  className: 'tide-circle-marker'
}

const calculateDomain = (stations) => {
  let min = d3.min(stations, (station) => {
    return d3.min(station.tideData, (d) => d.tide)
  })

  let max = d3.max(stations, (station) => {
    return d3.max(station.tideData, (d) => d.tide)
  })

  return [min, 0, max]
}

const findTide = ({ tideData }, year) => {
  let tideItem = tideData.find(item => item.year === year)
  return tideItem && tideItem.tide
}

const createMarkers = (stations, clickCallback) => {
  return stations.map(station => {
    const latLng = [station.latitude, station.longitude]
    const marker = L.circleMarker(latLng, MARKER_OPTIONS)
    marker.on('click', event => clickCallback(station.ID))
    return marker
  })
}

const ExplorerLayer = L.LayerGroup.extend({

  initialize: function (stations, clickCallback) {
    let domain = calculateDomain(stations)
    let colorScale = d3.scaleSqrt().domain(domain).range(COLORS)

    this._stations = stations
    this._circleMarkers = createMarkers(stations, clickCallback)
    this._initializeAnimation(colorScale)

    L.LayerGroup.prototype.initialize.call(this, this._circleMarkers)
  },

  onRemove: function (map) {
    clearInterval(this._animationLoop)
    L.LayerGroup.prototype.onRemove.call(this, map)
  },

  _initializeAnimation: function (colorScale) {
    let year = MIN_YEAR

    this._animationLoop = setInterval(() => {
      console.log(year)
      this._redraw(year++, colorScale)
      if (year > MAX_YEAR) clearInterval(this._animationLoop)
    }, 1000)
  },

  _redraw: function (year, colorScale) {
    this._circleMarkers.forEach((marker, i) => {
      const tide = findTide(this._stations[i], year)
      const color = colorScale(tide)

      marker.setStyle({
        color: d3.rgb(color).darker(0.2),
        fillColor: color
      })
    })
  }
})

export default (...args) => {
  return new ExplorerLayer(...args)
}
