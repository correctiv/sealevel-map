<sealevel-scrolly-map class="scrolly__map">

  <div id="scrolly__map" class="scrolly__map__container"></div>

  <sealevel-scrolly-map-animation
    if={stations && activeStep === 'world'}
    map={map} items={stations}
  />

  <sealevel-scrolly-map-visualization
    if={stations && activeStep !== 'world'}
    map={map} items={stations}
  />

  <script type="text/babel">
    import mapboxgl from 'mapbox-gl'
    import _ from 'lodash'
    import config from 'json!../../config/main.json'
    import { requestStationList } from '../../actions/explorer'
    import './scrolly-map-animation.tag'
    import './scrolly-map-visualization.tag'

    this.activeLayers = []
    this.state = this.store.getState()
    this.subscribe(state => this.update({ state }))

    this.shouldUpdate = (updates) => {
      if (updates) {
        const {navigation, explorer} = updates.state
        const stepChanged = navigation.activeStep !== this.activeStep
        const dataUnchanged = _.isEqual(explorer.items, this.stations)
        const dataAvailable = !dataUnchanged && _.isArray(explorer.items)
        return stepChanged || dataAvailable
      }
    }

    this.on('update', () => {
      this.activeStep = this.state.navigation.activeStep
      this.stations = this.state.explorer.items
    })

    this.on('updated', () => {
      this.map && updateLayers(this.activeStep)
    })

    this.on('mount', () => {
      this.map = renderMap()
      this.store.dispatch(requestStationList())
    })

    const BREAKPOINT = 1100
    const OFFSET = 220

    const isLargeViewport = () => (
      document.documentElement.clientWidth >= BREAKPOINT
    )

    const getOffset = (direction = 1) => (
      isLargeViewport() ? [OFFSET * direction, 0] : [0, 0]
    )

    const updateLayers = (activeStep) => {
      switch (activeStep) {

        case 'world':
          this.map.fitBounds([
            [-160, -55],
            [185.1, 75]
          ], { duration: 0 })
          break

        case 'manila':
          this.map.jumpTo({
            center: [121, 14.65],
            zoom: 9.5,
            offset: getOffset(-1)
          })
          break

        case 'scandinavia':
          this.map.fitBounds([
            [-25.18, 54.47],
            [32.82, 71.27]
          ], {
            offset: getOffset()
          })
          break

        case 'france':
          this.map.flyTo({
            center: [3.93, 43.52],
            zoom: 4,
            offset: getOffset(-1)
          })
          break

        case 'usa':
          this.map.flyTo({
            center: [-74, 31],
            zoom: 4,
            offset: getOffset()
          })
          break

        case 'argentina':
          this.map.flyTo({
            center: [-58, -35],
            zoom: 5,
            offset: getOffset(-1)
          })
          break
      }
    }

    const renderMap = () => {
      mapboxgl.accessToken = config.mapbox.accessToken

      const map = new mapboxgl.Map({
        container: 'scrolly__map',
        style: config.mapbox.style,
        zoom: 3
      })

      map.on('load', () => {
        // disable map zoom when using scroll
        map.scrollZoom.disable()

        // disable map rotation using right click + drag
        map.dragRotate.disable()

        // disable map rotation using touch rotation gesture
        map.touchZoomRotate.disableRotation()
      })

      return map
    }

  </script>
</sealevel-scrolly-map>
