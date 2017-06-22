<sealevel-scrolly-map class="scrolly__map">

  <div id="scrolly__map" class="scrolly__map__container"></div>

  <script type="text/babel">
    import mapboxgl from 'mapbox-gl'
    import * as d3 from 'd3'

    this.activeLayers = []
    this.state = this.store.getState()
    this.subscribe(state => this.update({ state }))

    this.on('updated', () => {
      const activeStep = this.state.navigation.activeStep
      this.map && updateLayers(activeStep)
    })

    this.on('mount', () => {
      this.map = renderMap()
      renderVizLayer(this.map)
    })

    const updateLayers = (activeStep) => {
      switch (activeStep) {

        case 'intro':
          this.map.fitBounds([
            [-167.6953125, -56.3652501369],
            [-166.9921875, 77.3895040054]
          ])
          break

        case 'manila':
          this.map.flyTo({
            center: [121, 14.65],
            zoom: 10
            })
          break

        case 'northern-europe':
          this.map.fitBounds([
            [-25.1806640625, 54.4700376128],
            [32.8271484375, 71.2725947123]
          ])
          break
      }
    }

    const renderMap = () => {
      mapboxgl.accessToken = 'pk.eyJ1IjoiZmVsaXhtaWNoZWwiLCJhIjoiZWZrazRjOCJ9.62fkOEqGMxFxJZPJuo2iIQ'

      const map = new mapboxgl.Map({
        container: 'scrolly__map',
        style: 'mapbox://styles/felixmichel/cj1550ogw002s2smkgbz60keh',
        center: [-103.59179687498357, 40.66995747013945],
        zoom: 3
      })

      return map
    }

    const renderVizLayer = (map) => {
      // Setup our svg layer that we can manipulate with d3
      const container = map.getCanvasContainer()
      const svg = d3.select(container).append('svg')

      this.points = this.opts.animationItems

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
      const d3Projection = getD3Projection(this.map)
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
</sealevel-scrolly-map>
