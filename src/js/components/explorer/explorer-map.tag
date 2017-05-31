<sealevel-explorer-map>

  <div id="explorer__map" class="explorer__map"></div>

  <script type="text/babel">
    import mapboxgl from 'mapbox-gl'

    this.activeLayers = []
    this.state = this.store.getState()
    this.subscribe(state => this.update({ state }))

    this.on('updated', () => {
      const activeStation = this.state.explorer.station

      activeStation && zoomToStation(activeStation)
    })

    this.on('mount', () => {
      this.map = renderMap(opts.options)
    })

    const zoomToStation = (target) => {
      this.map.flyTo({
        center: [target.longitude, target.latitude],
        zoom: 6,
        pitch: 0
      })
    }

    const createGeojsonSource = (stations) => ({
      type: 'geojson',
      data: {
        type: 'FeatureCollection',
        features: stations.map(station => ({
          type: 'Feature',
          geometry: {
            type: 'Point',
            coordinates: [station.longitude, station.latitude]
          },
          properties: {
            title: station.location
          }
        }))
      }
    })

    const renderMap = () => {
      mapboxgl.accessToken = 'pk.eyJ1IjoiZmVsaXhtaWNoZWwiLCJhIjoiZWZrazRjOCJ9.62fkOEqGMxFxJZPJuo2iIQ'

      const map = new mapboxgl.Map({
        container: 'explorer__map',
        style: 'mapbox://styles/felixmichel/cj1550ogw002s2smkgbz60keh',
        center: [-103.59179687498357, 40.66995747013945],
        zoom: 3
      })

      map.on('load', () => {
        map.addLayer({
          'id': 'stations',
          'type': 'circle',
          'source': createGeojsonSource(this.opts.stations),
          'layout': {
            'visibility': 'visible'
          },
          'paint': {
            'circle-radius': 5,
            'circle-color': 'rgba(55,148,179,1)'
          }
        })
      })

      return map
    }

  </script>
</sealevel-explorer-map>
