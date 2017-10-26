<sealevel-scrolly-map-visualization class="scrolly__map-visualization {
  scrolly__map-visualization--hidden: isMoving
}">

  <svg ref="vis" />

  <div class="container">
    <span class="scrolly__map-visualization__counter">
      { year }
    </span>
  </div>

  <script type="text/babel">
    import * as d3 from 'd3'

    const YEAR = 2015
    const HEIGHT = 500
    const WIDTH = 12

    this.isMoving = false

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

    const redraw = () => {
      const d3Projection = getD3Projection(this.opts.map)
      const path = d3.geoPath()
      path.projection(d3Projection)

      this.paths
        .attr('transform', (station) => {
          const point = d3Projection(station.lngLat)
          const tide = station.timeseries[YEAR] || 0
          const height = Math.abs(this.scale(tide) - this.scale(0))
          const x = point[0] - 3
          const y = tide <= 0 ? point[1] : point[1] - height

          return `translate(${x}, ${y})`
        })
        .attr('d', (station) => {
          const tide = station.timeseries[YEAR]
          const height = Math.abs(this.scale(tide) - this.scale(0))

          if (tide) {
            return tide >= 0
              ? `M ${WIDTH / 2},0 ${WIDTH}, ${height} 0, ${height} z`
              : `M 0 0 L ${WIDTH / 2} ${height} L ${WIDTH} 0 z`
          } else {
            return `M 0 0 L ${WIDTH / 2} 0 L ${WIDTH} 0 z`
          }
        })
        .attr('class', (station) => {
          return station.timeseries[YEAR] < 0
            ? 'scrolly__map-visualization__item--negative'
            : 'scrolly__map-visualization__item--positive'
        })
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
