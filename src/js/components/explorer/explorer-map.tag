<sealevel-explorer-map>

  <div id="explorer__map" class="explorer__map"></div>

  <script type="text/babel">
    import mapboxgl from 'mapbox-gl'
    import bbox from '@turf/bbox'

    const scale = [
      [-4, '#008080'],
      [-2, '#94d5ba'],
      [0, '#ffffe0'],
      [2, '#ef738b'],
      [4, '#8b0000']
    ]

    this.activeLayers = []
    this.state = this.store.getState()
    this.subscribe(state => this.update({ state }))

    this.on('updated', () => {
      const stations = this.opts.stations
      const continent = this.opts.continent
      const station = this.opts.station

      continent && zoomToContinent(continent, stations)
      station && zoomToStation([station.longitude, station.latitude])
    })

    this.on('mount', () => {
      this.map = renderMap(opts.options)
    })

    const createFeatures = (stations) => ({
      type: 'FeatureCollection',
      features: stations.map(station => ({
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [
            parseFloat(station.longitude),
            parseFloat(station.latitude)
          ]
        },
        properties: {
          id: station.id,
          title: station.location,
          trend: parseFloat(station.trend_1985_2015, 10)
        }
      }))
    })

    const zoomToContinent = (id, stations) => {
      const selectedStations = stations.filter(({ continent }) => id === continent)
      const bounds = bbox(createFeatures(selectedStations))
      this.map.fitBounds(bounds)
    }

    const zoomToStation = (coordinates) => {
      this.map.flyTo({
        center: coordinates,
        zoom: 6,
        pitch: 0
      })
    }

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
          id: 'stations',
          type: 'circle',
          source: {
            type: 'geojson',
            data: createFeatures(this.opts.stations)
          },
          layout: {
            visibility: 'visible'
          },
          paint: {
            'circle-radius': 5,
            'circle-color': {
              property: 'trend',
              stops: scale
            }
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
