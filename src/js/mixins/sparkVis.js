import * as d3 from 'd3'

const renderSpark = (width, height, tide) => {
  if (!tide) {
    return `M 0 0 L ${width / 2} 0 L ${width} 0 z`
  } else if (tide > 0) {
    return `M ${width / 2}, 0 ${width}, ${height} 0, ${height} z`
  } else if (tide < 0) {
    return `M 0 0 L ${width / 2} ${height} L ${width} 0 z`
  }
}

const getDomain = (stations) => {
  let yMin = d3.min(stations, (station) => {
    return d3.min(station.timeseries)
  })

  let yMax = d3.max(stations, (station) => {
    return d3.max(station.timeseries)
  })

  return [yMin, yMax]
}

// map projection between map and vis
// adapted from http://bl.ocks.org/enjalot/0d87f32a1ccb9a720d29ba74142ba365
const getD3Projection = (map) => {
  var bbox = map.getCanvas().getBoundingClientRect()
  var center = map.getCenter()
  var zoom = map.getZoom()

  // 512 is hardcoded tile size, might need to be 256 or changed to suit your map config
  var scale = (512) * 0.5 / Math.PI * Math.pow(2, zoom)

  var d3projection = d3.geoMercator()
    .center([center.lng, center.lat])
    .translate([bbox.width / 2, bbox.height / 2])
    .scale(scale)

  return d3projection
}

export default function (opts) {
  const { width, height, stations, tooltip, map } = opts
  let year = opts.year

  const scale = d3.scaleLinear()
    .rangeRound([height, 0])
    .domain(getDomain(stations))

  const getTide = (timeseries, year) => {
    let tide = timeseries[year]
    while (typeof tide === 'undefined') {
      tide = timeseries[year -= 1]
    }
    return tide
  }

  return {
    init: function () {
      d3.select(opts.container)
        .selectAll('path')
        .data(stations)
        .enter()
        .append('path')

      // redraw visualization whenever the view changes
      map.on('viewreset', () => this.sparkVis.redraw())
      map.on('move', () => this.sparkVis.redraw())

      this.sparkVis = {
        redraw: (updatedYear) => {
          year = updatedYear || year
          const d3Projection = getD3Projection(map)
          const path = d3.geoPath()
          path.projection(d3Projection)

          d3.select(opts.container)
            .selectAll('path')
            .attr('transform', (station) => {
              const {latitude, longitude, timeseries} = station
              const point = d3Projection([longitude, latitude])
              const tide = getTide(timeseries, year)
              const height = Math.abs(scale(tide) - scale(0))
              const x = point[0] - 3
              const y = tide <= 0 ? point[1] : point[1] - height
              return `translate(${x}, ${y})`
            })
            .attr('d', (station) => {
              const tide = getTide(station.timeseries, year)
              const height = Math.abs(scale(tide) - scale(0))
              return renderSpark(width, height, tide)
            })
            .attr('class', (station) => {
              return getTide(station.timeseries, year) < 0
                ? 'scrolly__map-visualization__item--negative'
                : 'scrolly__map-visualization__item--positive'
            })
            .on('mouseover', (station) => {
              tooltip.show(station, d3Projection([station.longitude, station.latitude]))
            })
            .on('mouseout', () => {
              tooltip.hide()
            })

          this.trigger('redraw', d3Projection)
        }
      }
    }
  }
}
