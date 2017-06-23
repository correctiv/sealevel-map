<sealevel-scrolly-map-animation>

  <svg id="scrolly__map__animation" />

  <script type="text/babel">
    import * as d3 from 'd3'

    this.on('update', () => {
      renderVizLayer(this.opts.map)
    })

    this.shouldUpdate = (opts, nextOpts) => {
      if (this.points === nextOpts.items) return false
      return true
    }

    const renderVizLayer = (map) => {
      // Setup our svg layer that we can manipulate with d3
      const container = map.getCanvasContainer()
      const svg = d3.select(container).append('svg')

      this.points = this.opts.items

      if (this.points.length > 0) {
        this.dots = svg.selectAll('circle')
          .data(this.points)
          .enter()
          .append('circle')

        // re-render our visualization whenever the view changes
        map.on('viewreset', render)
        map.on('move', render)

        // initial rendering
        render()
      }
    }

    const render = () => {
      const d3Projection = getD3Projection(this.opts.map)
      const path = d3.geoPath()
      path.projection(d3Projection)

      this.dots
        .attr('r', 10)
        .style('fill', 'green')
        .attr('cx', d => d3Projection([d.longitude, d.latitude])[0])
        .attr('cy', d => d3Projection([d.longitude, d.latitude])[1])
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
</sealevel-scrolly-map-animation>
