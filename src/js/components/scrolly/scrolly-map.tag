<sealevel-scrolly-map class="scrolly__map">

  <div id="scrolly__map" class="scrolly__map__container"></div>

  <sealevel-scrolly-map-animation
    if={map}
    items={state.animation.items}
    map={map}
  />

  <script type="text/babel">
    import mapboxgl from 'mapbox-gl'
    import './scrolly-map-animation.tag'
    import { fetchAnimationDataIfNeeded } from '../../actions/animation'

    this.activeLayers = []
    this.state = this.store.getState()
    this.subscribe(state => this.update({ state }))

    this.on('updated', () => {
      const activeStep = this.state.navigation.activeStep
      this.map && updateLayers(activeStep)
    })

    this.on('mount', () => {
      this.map = renderMap()
      this.store.dispatch(fetchAnimationDataIfNeeded())
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
      return new mapboxgl.Map({
        container: 'scrolly__map',
        style: 'mapbox://styles/felixmichel/cj1550ogw002s2smkgbz60keh',
        center: [-103.59179687498357, 40.66995747013945],
        zoom: 3
      })
    }

  </script>
</sealevel-scrolly-map>
