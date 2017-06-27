<sealevel-scrolly-map-animation>

  <svg id="scrolly__map__animation" />

  <script type="text/babel">
    import * as d3 from 'd3'

    const MIN_YEAR = 1985
    const MAX_YEAR = 2014
    const ANIMATION_INTERVAL = 1000
    const MAX_HEIGHT = 200

    this.on('update', () => {
      initialize(this.opts.map)
    })

    this.shouldUpdate = (opts, nextOpts) => {
      if (this.stations === nextOpts.items) return false
      return true
    }

    const initialize = (map) => {
      // Setup our svg layer that we can manipulate with d3
      const container = map.getCanvasContainer()
      const svg = d3.select(container).append('svg')

      this.stations = this.opts.items

      if (this.stations.length > 0) {
        this.paths = svg.selectAll('path')
          .data(this.stations)
          .enter()
          .append('path')

        const domain = getDomainValues(this.stations)
        this.scale = d3.scaleLinear().rangeRound([MAX_HEIGHT, 0]).domain(domain)

        // initial rendering
        startAnimation()

        // re-render our visualization whenever the view changes
        map.on('viewreset', redraw)
        map.on('move', redraw)
      }
    }

    const startAnimation = () => {
      this.year = MIN_YEAR

      this.animationLoop = setInterval(() => {
        console.log(this.year)
        this.year++
        redraw()
        if (this.year > MAX_YEAR) stopAnimation()
      }, ANIMATION_INTERVAL)
    }

    const stopAnimation = () => {
      clearInterval(this.animationLoop)
    }

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

    const redraw = () => {
      const d3Projection = getD3Projection(this.opts.map)
      const path = d3.geoPath()
      path.projection(d3Projection)

      this.paths
        .transition(ANIMATION_INTERVAL)
        .attr('transform', (station) => {
          const point = d3Projection([station.longitude, station.latitude])
          const tide = findTide(station, this.year)
          const triangleHeight = Math.abs(this.scale(tide) - this.scale(0))
          const x = point[0] - 3
          const y = tide <= 0 ? point[1] : point[1] - triangleHeight

          return `translate(${x}, ${y})`
        })
        .attr('d', (station) => {
          const tide = findTide(station, this.year)
          const triangleHeight = Math.abs(this.scale(tide) - this.scale(0))

          if (tide) {
            if (tide >= 0) {
              return 'M 3,0 6,' + triangleHeight + ' 0,' + triangleHeight + ' z'
            } else {
              return 'M 0 0 L 3 ' + triangleHeight + ' L 6 0 z'
            }
          } else {
            return 'M 0 0 L 3 0 L 6 0 z'
          }
        })
        .attr('class', (station) => {
          return findTide(station, this.year) < 0
            ? 'scrolly__map-animation__item--negative'
            : 'scrolly__map-animation__item--positive'
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
</sealevel-scrolly-map-animation>
