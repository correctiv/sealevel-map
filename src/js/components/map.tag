<sealevel-map>

  <div id="sealevel__map" class="sealevel__map"></div>

  <script type="text/babel">
    import L from 'leaflet'
    import 'leaflet_css'
    import 'leaflet_marker'
    import 'leaflet_marker_2x'
    import 'leaflet_marker_shadow'
    import { fetchAnimationDataIfNeeded } from '../actions/animation'
    import tideOverTimeLayer from './layers/tide-over-time-layer.js'
    import explorerLayer from './layers/explorer-layer.js'
    import { STEPS, routeToStation } from '../routes/'

    this.activeLayers = []
    this.state = this.store.getState()
    this.subscribe(state => this.update({ state }))

    this.on('updated', () => {
      const activeStep = this.state.navigation.activeStep
      const activeStation = this.state.explorer.station

      console.log(activeStep, this.state.animation.items)
      updateLayers(activeStep)
      zoomToStation(activeStation)
    })

    this.on('mount', () => {
      this.map = renderMap(opts.options)
      this.dispatch(fetchAnimationDataIfNeeded())
    })

    const updateLayers = (activeStep) => {
      switch (activeStep) {

        case STEPS.EXPERIMENT_1:
          clearLayers()
          addLayer(explorerLayer({
            stations: this.state.animation.items,
            clickCallback: routeToStation,
            isAnimated: true
          }))
          break

        case STEPS.EXPERIMENT_2:
          clearLayers()
          addLayer(tideOverTimeLayer(this.state.animation.items))
          break

        default:
          clearLayers()
          addLayer(explorerLayer({
            stations: this.state.animation.items,
            clickCallback: routeToStation,
            isAnimated: false
          }))
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
