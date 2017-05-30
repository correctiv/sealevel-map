<sealevel-map>

  <div id="sealevel__map" class="sealevel__map"></div>

  <script type="text/babel">
    import mapboxgl from 'mapbox-gl'
    import { fetchAnimationDataIfNeeded } from '../actions/animation'

    this.activeLayers = []
    this.state = this.store.getState()
    this.subscribe(state => this.update({ state }))

    this.on('updated', () => {
      const activeStep = this.state.navigation.activeStep
      const activeStation = this.state.explorer.station

      updateLayers(activeStep)
      zoomToStation(activeStation)
    })

    this.on('mount', () => {
      this.map = renderMap(opts.options)
      this.dispatch(fetchAnimationDataIfNeeded())
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
            zoom: 10,
            pitch: 45
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

    const zoomToStation = (target) => {
      if (target) {
        this.map.flyTo({
          center: [target.longitude, target.latitude],
          zoom: 6,
          pitch: 0
        })
      }
    }

    const renderMap = ({ center, zoom, tiles, attribution }) => {
      mapboxgl.accessToken = 'pk.eyJ1IjoiZmVsaXhtaWNoZWwiLCJhIjoiZWZrazRjOCJ9.62fkOEqGMxFxJZPJuo2iIQ'

      const map = new mapboxgl.Map({
        container: 'sealevel__map',
        style: 'mapbox://styles/felixmichel/cj1550ogw002s2smkgbz60keh',
        center: [-103.59179687498357, 40.66995747013945],
        zoom: 3
      })

      return map
    }

  </script>
</sealevel-map>
