<sealevel-explorer-map>

  <div id="explorer__map" class="explorer__map"></div>

  <script type="text/babel">
    import mapboxgl from 'mapbox-gl'
    import _ from 'lodash'
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
      flyToSelection(this.opts)
      this.opts.station && highlightStation(this.opts.station)
    })

    this.on('mount', () => {
      this.map = renderMap(opts.options)
    })

    const highlightStation = ({longitude, latitude}) => {
      const markerEl = document.createElement('div')
      markerEl.className = 'explorer__map__highlight'

      // remove existing marker:
      this.marker && this.marker.remove()

      // add new marker:
      this.marker = new mapboxgl.Marker(markerEl, { offset: [-10, -10] })
        .setLngLat([longitude, latitude])
        .addTo(this.map)
    }

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

    const filterSelection = ({ stations, station, country, continent }) => {
      if (continent) {
        return _.filter(stations, { continent })
      } else if (country) {
        return _.filter(stations, { country })
      } else if (station) {
        return [station]
      } else {
        return stations
      }
    }

    const flyToSelection = (options) => {
      const selection = filterSelection(options)
      const bounds = bbox(createFeatures(selection))
      this.map.fitBounds(bounds, {
        duration: 1000,
        maxZoom: 7,
        offset: [-200, 0]
      })
    }

    const renderMap = () => {
      mapboxgl.accessToken = 'pk.eyJ1IjoiZmVsaXhtaWNoZWwiLCJhIjoiZWZrazRjOCJ9.62fkOEqGMxFxJZPJuo2iIQ'

      const map = new mapboxgl.Map({
        container: 'explorer__map',
        style: 'mapbox://styles/felixmichel/cj1550ogw002s2smkgbz60keh'
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
            'circle-radius': 6,
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

          // remove existing popup:
          this.popup && this.popup.remove()

          // create new popup:
          this.popup = new mapboxgl.Popup({
            offset: [0, -15],
            closeOnClick: false,
            closeButton: false
          })
          .setLngLat(target.geometry.coordinates)
          .setHTML(target.properties.title)
          .addTo(map)
        })

        map.on('load', () => {
          // Set locale for map features
          const locale = this.i18n.getLocale()
          map.setLayoutProperty('place_label_city', 'text-field', `{name_${locale}}`)
          map.setLayoutProperty('place_label_other', 'text-field', `{name_${locale}}`)
          map.setLayoutProperty('country_label', 'text-field', `{name_${locale}}`)

          // Disable map rotation using right click + drag
          map.dragRotate.disable()

          // Disable map rotation using touch rotation gesture
          map.touchZoomRotate.disableRotation()
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
