<sealevel-scrolly-map-visualization class="scrolly__map-visualization {
  scrolly__map-visualization--hidden: isMoving
}">

  <svg>
    <g ref="vis" />
    <g ref="annotations" />
  </svg>

  <sealevel-scrolly-map-visualization-tooltip
    if={tooltip}
    value={tooltip.value}
    location={tooltip.location}
    position={tooltip.position}
  />

  <script type="text/babel">
    import * as d3 from 'd3'
    import * as d3Annotation from 'd3-svg-annotation'
    import './scrolly-map-visualization-tooltip.tag'

    const MIN_YEAR = 1985
    const MAX_YEAR = 2015
    const HEIGHT = 500
    const WIDTH = 12

    const customAnnotation = d3Annotation.annotationCustomType(
      d3Annotation.annotationCallout, {
        'className': 'custom',
        'connector': { 'end': 'dot' },
        'note': { 'lineType': 'horizontal' }
      })

    const labels = [{
      data: { lonLat: ['120.968', '14.58'] },
      note: {
        title: 'Der Pegel Manila',
        label: 'ist in 30 Jahren um fast 40cm gestiegen.'
      },
      dy: 30,
      dx: -30,
      type: customAnnotation,
      color: 'black'
    },
    {
      data: {
        lonLat: ['120.91', '14.71']
      },
      note: {
        title: 'Besonders gefährdet',
        label: 'sind Gebiete unterhalb von 10 Meter über dem Meer.'
      },
      dy: 30,
      dx: -30,
      type: customAnnotation,
      color: 'black'
    }]

    this.isMoving = true
    this.tooltip = null

    this.on('mount', () => {
      initialize(this.opts.map, this.opts.items)

      // synchronize state with map movement (for hiding/showing)
      this.opts.map.on('movestart', isMoving)
      this.opts.map.on('moveend', isMoving)

      // redraw visualization whenever the view changes
      this.opts.map.on('viewreset', redraw)
      this.opts.map.on('move', redraw)
    })

    this.on('unmount', () => {
      // remove map event handlers before unmounting
      this.opts.map.off('movestart', isMoving)
      this.opts.map.off('moveend', isMoving)
      this.opts.map.off('movestart', isMoving)
      this.opts.map.off('moveend', isMoving)
    })

    const initialize = (map, stations) => {
      const svg = d3.select(this.refs.vis)

      if (stations.length > 0) {
        this.paths = svg.selectAll('path')
          .data(stations)
          .enter()
          .append('path')

        const domain = getDomainValues(stations)
        this.scale = d3.scaleLinear().rangeRound([HEIGHT, 0]).domain(domain)

        // initial rendering
        redraw()
      }
    }

    const isMoving = () => {
      this.update({
        isMoving: opts.map.isMoving()
      })
    }

    function getDomainValues (items) {
      let yMin = d3.min(items, (station) => {
        return d3.min(station.timeseries)
      })

      let yMax = d3.max(items, (station) => {
        return d3.max(station.timeseries)
      })

      return [yMin, yMax]
    }

    const isDefined = (value) => typeof value !== 'undefined'

    const getTide = (timeseries) => {
      const minValue = timeseries[MIN_YEAR]
      const maxValue = timeseries[MAX_YEAR]

      if (isDefined(minValue) && isDefined(maxValue)) {
        return maxValue - minValue
      }

      return 0
    }

    const showTip = ({ location, timeseries }, position) => {
      this.update({
        tooltip: {
          location,
          value: getTide(timeseries),
          position
        }
      })
    }

    const hideTip = () => {
      this.update({ tooltip: null })
    }

    const redraw = () => {
      const d3Projection = getD3Projection(this.opts.map)
      const path = d3.geoPath()
      path.projection(d3Projection)

      const makeAnnotations = d3Annotation.annotation()
        .annotations(labels)
        .textWrap(180)
        .accessors({
          x: ({ lonLat }) => d3Projection(lonLat)[0],
          y: ({ lonLat }) => d3Projection(lonLat)[1]
        })

      d3.select(this.refs.annotations)
        .call(makeAnnotations)

      this.paths
        .attr('transform', (station) => {
          const point = d3Projection([station.longitude, station.latitude])
          const tide = getTide(station.timeseries)
          const height = Math.abs(this.scale(tide) - this.scale(0))
          const x = point[0] - 3
          const y = tide <= 0 ? point[1] : point[1] - height
          return `translate(${x}, ${y})`
        })
        .attr('d', (station) => {
          const tide = getTide(station.timeseries)
          const height = Math.abs(this.scale(tide) - this.scale(0))
          return renderSpark(WIDTH, height, tide)
        })
        .attr('class', (station) => {
          return getTide(station.timeseries) < 0
            ? 'scrolly__map-visualization__item--negative'
            : 'scrolly__map-visualization__item--positive'
        })
        .on('mouseover', (station) => {
          console.log(station)
          showTip(station, d3Projection([station.longitude, station.latitude]))
        })
        .on('mouseout', () => {
          hideTip()
        })
    }

    const renderSpark = (width, height, tide) => {
      if (!tide) {
        return `M 0 0 L ${width / 2} 0 L ${width} 0 z`
      } else if (tide > 0) {
        return `M ${width / 2}, 0 ${width}, ${height} 0, ${height} z`
      } else if (tide < 0) {
        return `M 0 0 L ${width / 2} ${height} L ${width} 0 z`
      }
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

  </script>
</sealevel-scrolly-map-visualization>
