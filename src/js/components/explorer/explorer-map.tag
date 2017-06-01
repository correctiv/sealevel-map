<sealevel-explorer-map>

  <div id="explorer__map" class="explorer__map"></div>

  <script type="text/babel">
    import mapboxgl from 'mapbox-gl'

    this.activeLayers = []
    this.state = this.store.getState()
    this.subscribe(state => this.update({ state }))

    this.on('updated', () => {
      const station = this.state.explorer.station
      station && zoomToStation([station.longitude, station.latitude])
    })

    this.on('mount', () => {
      this.map = renderMap(opts.options)
    })

    const zoomToStation = (coordinates) => {
      this.map.flyTo({
        center: coordinates,
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
            id: station.id,
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

        // location of the feature, with description HTML from its properties.
        map.on('click', 'stations', ({ features }) => {
          const target = features[0]
          const locale = this.i18n.getLocale()

          this.opts.routeToStation(locale, target.properties.id)

          new mapboxgl.Popup()
            .setLngLat(target.geometry.coordinates)
            .setHTML(target.properties.title)
            .addTo(map)
        })

        // Change the cursor to a pointer when the mouse is over the stations layer.
        map.on('mouseenter', 'stations', () => {
          map.getCanvas().style.cursor = 'pointer'
        })

        // Change it back to a pointer when it leaves.
        map.on('mouseleave', 'stations', () => {
          map.getCanvas().style.cursor = ''
        })
      })

      return map
    }

  </script>
</sealevel-explorer-map>
