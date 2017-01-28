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

let _stations
let _domain
let _colorScale

function getDomainValues (stations) {
  let min = d3.min(stations, (station) => {
    return d3.min(station.tideData, (d) => d.tide)
  })

  let max = d3.max(stations, (station) => {
    return d3.max(station.tideData, (d) => d.tide)
  })

  return [min, 0, max]
}

function findTide ({ tideData }, year) {
  let tideItem = tideData.find(item => item.year === year)
  return tideItem && tideItem.tide
}

function initialize (stations) {
  _stations = stations
  _domain = getDomainValues(stations)
  _colorScale = d3.scaleSqrt().domain(_domain).range(COLORS)

  let circleMarkers = initializeMarkers()
  initializeAnimation(circleMarkers)

  return L.layerGroup(circleMarkers)
}

function initializeAnimation (circleMarkers) {
  /* animate circle color over time  */
  let year = MIN_YEAR
  const animationLoop = setInterval(() => {
    console.log(year)
    redraw(circleMarkers, year++)
    if (year > MAX_YEAR) clearInterval(animationLoop)
  }, 1000)
}

function initializeMarkers () {
  return _stations.map(station => {
    const latLng = [station.latitude, station.longitude]
    const marker = L.circleMarker(latLng, MARKER_OPTIONS)
    marker.bindPopup(station.location)
    return marker
  })
}

function redraw (circleMarkers, year) {
  circleMarkers.forEach((marker, i) => {
    const tide = findTide(_stations[i], year)
    const color = _colorScale(tide)

    marker.setStyle({
      color: d3.rgb(color).darker(0.2),
      fillColor: color
    })
  })
}

export default {
  addTo: (map, stations) => {
    const markerLayer = initialize(stations)
    markerLayer.addTo(map)
  },
  redraw: redraw
}
