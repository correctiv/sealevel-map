<sealevel-map>

  <sealevel-map-slider if="{ this.next }" value="{ this.year }" oninput="{ this.onSliderInput }" class="slider"></sealevel-map-slider>

  <div if="{ this.opts.active === 0 }" class="sealevel__map__infobox">
    <h2>Data Explorer (WIP)</h2>
    <p>Change in tides 1985 - 2014</p>
    <p>Click on an item to learn more.</p>
    <a href="#{this.opts.steps[1]}">Show animation</a>
  </div>

  <div if="{ this.opts.active === 1 }" class="sealevel__map__infobox">
    <h2>Simple animation (WIP)</h2>
    <p>Change in tides 1985 - 2014</p>
    <a href="#{this.opts.steps[2]}">Show another animation (experimental)</a>
  </div>

  <div if="{ this.opts.active === 2 }" class="sealevel__map__infobox">
    <h2>Experimental animation (WIP)</h2>
    <p>Change in tides 1985 - 2014</p>
    <a href="#{this.opts.steps[3]}">Explore the data</a>
  </div>

  <div id="sealevel__map" class="sealevel__map"></div>

  <script type="text/babel">
    import L from 'leaflet'
    import 'leaflet_css'
    import 'leaflet_marker'
    import 'leaflet_marker_2x'
    import 'leaflet_marker_shadow'
    import tideOverTimeLayer from './layers/tide-over-time-layer.js'
    import explorerLayer from './layers/explorer-layer.js'

    this.activeLayers = []

    this.on('updated', () => {
      const activeStep = this.opts.state.navigation.activeStep
      const activeStation = this.opts.state.explorer.station

      if (activeStep) updateLayers(activeStep)
      zoomToStation(activeStation)
    })

    this.on('mount', () => {
      this.map = renderMap(opts.options)
    })

    const updateLayers = (activeStep) => {
      switch (activeStep) {
        case 0:
          clearLayers()
          addLayer(explorerLayer({
            stations: opts.state.animation.items,
            clickCallback: opts.routes.routeToStation,
            isAnimated: false
          }))
          break

        case 1:
          clearLayers()
          addLayer(explorerLayer({
            stations: opts.state.animation.items,
            clickCallback: opts.routes.routeToStation,
            isAnimated: true
          }))
          break

        case 2:
          clearLayers()
          addLayer(tideOverTimeLayer(opts.state.animation.items))
          break
      }
    }

    const zoomToStation = (target) => {
      if (target) {
        this.map.setView([target.latitude, target.longitude], 6)
      }
    }

    const renderMap = ({ center, zoom, tiles, attribution }) => {
      const map = L.map('sealevel__map', { center, zoom })
      const tileLayer = L.tileLayer(tiles, { attribution })

      map.addLayer(tileLayer)
      map.zoomControl.setPosition('topleft')

      return map
    }

    const addLayer = (layer) => {
      this.map.addLayer(layer)
      this.activeLayers.push(layer)
    }

    const clearLayers = () => {
      this.activeLayers.forEach(layer => {
        this.map.removeLayer(layer)
      })
      this.activeLayers = []
    }
  </script>
</sealevel-map>
