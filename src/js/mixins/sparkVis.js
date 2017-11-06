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
  const { width, height, stations, map } = opts
  const tooltip = opts.tooltip || {}
  const animationDuration = opts.animationDuration || 0
  let year = opts.year || 0

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

  const getClassName = (station) => {
    return getTide(station.timeseries, year) < 0
      ? 'scrolly__map-visualization__item--negative'
      : 'scrolly__map-visualization__item--positive'
  }

  const getSparkHeight = (tide) => {
    const height = Math.abs(scale(tide) - scale(0))
    return height > width ? height : width
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
      map.on('moveend', () => this.sparkVis.redraw())

      this.sparkVis = {
        redraw: (updatedYear) => {
          year = updatedYear || year

          const projection = getD3Projection(map)
          d3.geoPath().projection(projection)

          d3.select(opts.container)
            .selectAll('path')
            .on('mouseover', (station) => {
              const {location, latitude, longitude} = station
              const tide = getTide(station.timeseries, year)
              const point = projection([longitude, latitude])
              tooltip.show({ location, tide, point })
            })
            .on('mouseout', tooltip.hide)
            .attr('class', getClassName)
            .transition()
            .duration(animationDuration)
            .attr('transform', (station) => {
              const {latitude, longitude, timeseries} = station
              const point = projection([longitude, latitude])
              const tide = getTide(timeseries, year)
              const height = getSparkHeight(tide)
              const x = point[0] - width / 2
              const y = tide <= 0 ? point[1] : point[1] - height
              return `translate(${x}, ${y})`
            })
            .attr('d', (station) => {
              const tide = getTide(station.timeseries, year)
              const height = getSparkHeight(tide)
              return renderSpark(width, height, tide)
            })

          this.trigger('redraw', projection)
        }
      }
    }
  }
}
