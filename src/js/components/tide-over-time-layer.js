import * as d3 from 'd3'
import LeafletD3Layer from '../lib/leaflet-d3-layer.js'

const MIN_YEAR = 1985
const MAX_YEAR = 2014
const ANIMATION_INTERVAL = 1000
const MAX_HEIGHT = 200

var _stations, _selection, _projection, _animationLoop

function findTide ({ tideData }, year) {
  let tideItem = tideData.find(item => item.year === year)
  return tideItem && tideItem.tide
}

function getDomainValues (items) {
  let yMin = d3.min(items, (station) => {
    return d3.min(station.tideData, (d) => d.tide)
  })

  let yMax = d3.max(items, (station) => {
    return d3.max(station.tideData, (d) => d.tide)
  })

  return [yMin, yMax]
}

function initializeVisualization (selection, projection, stations) {
  _projection = projection
  _selection = selection
  _stations = stations

  _selection.selectAll('path')
    .data(_stations)
    .enter().append('path')
}

function initializeAnimation (scale) {
  let year = MIN_YEAR

  _animationLoop = setInterval(() => {
    console.log(year)
    redraw(year++, scale)
    if (year > MAX_YEAR) clearInterval(_animationLoop)
  }, ANIMATION_INTERVAL)
}

function redraw (year, scale) {
  _selection.selectAll('path')
    .data(_stations)
    .transition()
    .duration(150)
    .attr('d', function (station) {
      const tide = findTide(station, year)
      if (tide) {
        const triangleHeight = Math.abs(scale(tide) - scale(0))
        if (tide >= 0) {
          return 'M 3,0 6,' + triangleHeight + ' 0,' + triangleHeight + ' z'
        } else {
          return 'M 0 0 L 3 ' + triangleHeight + ' L 6 0 z'
        }
      } else {
        return 'M 0 0 L 3 0 L 6 0 z'
      }
    })
    .attr('transform', function (station) {
      let latLng = [station.latitude, station.longitude]
      let point = _projection.latLngToLayerPoint(latLng)
      let x = point.x - 3
      let yNeg = point.y
      let tide = findTide(station, year)

      if (tide) {
        let triangleHeight = Math.abs(scale(tide) - scale(0))
        let yPos = yNeg - triangleHeight
        if (tide >= 0) {
          return 'translate(' + x + ',' + yPos + ')'
        } else {
          return 'translate(' + x + ',' + yNeg + ')'
        }
      } else {
        return 'translate(' + x + ',' + yNeg + ')'
      }
    })
    .attr('class', function (station) {
      return findTide(station, year) < 0 ? 'negative' : 'positive'
    })
}

export default (stations) => {
  return LeafletD3Layer((selection, projection) => {
    /* set domain and scale */
    const domain = getDomainValues(stations)
    const scale = d3.scaleLinear().rangeRound([MAX_HEIGHT, 0]).domain(domain)

    initializeVisualization(selection, projection, stations)
    initializeAnimation(scale)
  })
}
