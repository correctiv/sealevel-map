<sealevel-scrolly-map class="scrolly__map">

  <div id="scrolly__map" class="scrolly__map__container"></div>

  <sealevel-scrolly-map-animation
    if={state.animation.items && activeStep === 'world'}
    map={map} items={state.animation.items}
  />

  <script type="text/babel">
    import mapboxgl from 'mapbox-gl'
    import './scrolly-map-animation.tag'
    import { fetchAnimationDataIfNeeded } from '../../actions/animation'

    this.activeLayers = []
    this.state = this.store.getState()
    this.subscribe(state => this.update({ state }))

    this.on('update', () => {
      this.activeStep = this.state.navigation.activeStep
    })

    this.on('updated', () => {
      this.map && updateLayers(this.activeStep)
    })

    this.on('mount', () => {
      this.map = renderMap()
      this.store.dispatch(fetchAnimationDataIfNeeded())
    })

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
            zoom: 10
          })
          break

        case 'scandinavia':
          this.map.fitBounds([
            [-25.1806640625, 54.4700376128],
            [32.8271484375, 71.2725947123]
          ], { duration: 300 })
          break

        case 'japan':
          this.map.flyTo({
            center: [139.683333, 35.683333],
            zoom: 5
          })
          break

        case 'france':
          this.map.flyTo({
            center: [3.930556, 43.529444],
            zoom: 5
          })
          break

        case 'argentina':
          this.map.flyTo({
            center: [-58.383333, -34.6],
            zoom: 5
          })
          break
      }
    }

    const renderMap = () => {
      mapboxgl.accessToken = 'pk.eyJ1IjoiZmVsaXhtaWNoZWwiLCJhIjoiZWZrazRjOCJ9.62fkOEqGMxFxJZPJuo2iIQ'
      const map = new mapboxgl.Map({
        container: 'scrolly__map',
        style: 'mapbox://styles/felixmichel/cj1550ogw002s2smkgbz60keh',
        zoom: 3
      })

      map.on('load', () => {
        const locale = this.i18n.getLocale()
        map.setLayoutProperty('place_label_city', 'text-field', `{name_${locale}}`)
        map.setLayoutProperty('place_label_other', 'text-field', `{name_${locale}}`)
        map.setLayoutProperty('country_label', 'text-field', `{name_${locale}}`)

        updateLayers('world')
      })

      return map
    }

  </script>
</sealevel-scrolly-map>
