<sealevel-explorer-map>

  <div id="explorer__map" class="explorer__map"></div>

  <div class="explorer__map__legend">
    {i18n.t('explorer.legend')}
  </div>

  <script type="text/babel">
    import mapboxgl from 'mapbox-gl'
    import MapboxglLanguage from '@mapbox/mapbox-gl-language'
    import _ from 'lodash'
    import bbox from '@turf/bbox'
    import config from 'json!../../config/main.json'

    const scale = [
      [-Infinity, '#469e9f'],
      [-2, '#7aa1a3'],
      [-0.5, '#9fa4a6'],
      [+0.5, '#9f7b7e'],
      [+2, '#9d474b']
    ]

    const zoomThreshold = 4

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

    const highlightStation = (id) => {
      const station = _.find(this.opts.stations, { id })
      const markerEl = document.createElement('div')
      markerEl.className = 'explorer__map__highlight'

      // remove existing marker:
      this.marker && this.marker.remove()

      // add new marker:
      this.marker = new mapboxgl.Marker(markerEl, { offset: [-10, -10] })
        .setLngLat([
          parseFloat(station.longitude),
          parseFloat(station.latitude)
        ])
        .addTo(this.map)
    }

    const createFeatures = (stations) => {
      return {
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
            trend: Number(station.trend)
          }
        }))
      }
    }

    const filterSelection = ({ stations, station, country, continent }) => {
      if (continent) {
        return _.filter(stations, { continent })
      } else if (country) {
        return _.filter(stations, { country })
      } else if (station) {
        return [_.find(stations, ({ id }) => id === station)]
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
        offset: [200, 0]
      })
    }

    const showPopup = ({ features }) => {
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
      .addTo(this.map)
    }

    const renderMap = () => {
      mapboxgl.accessToken = config.mapbox.accessToken

      const map = new mapboxgl.Map({
        container: 'explorer__map',
        style: config.mapbox.style,
        maxZoom: 8
      })

      map.on('load', () => {
        map.addLayer({
          id: 'stations_small',
          type: 'circle',
          maxzoom: zoomThreshold,
          source: {
            type: 'geojson',
            data: createFeatures(this.opts.stations)
          },
          paint: {
            'circle-radius': 3,
            'circle-color': {
              property: 'trend',
              type: 'interval',
              stops: scale
            }
          }
        })

        map.addLayer({
          id: 'stations_large',
          type: 'circle',
          minzoom: zoomThreshold,
          source: {
            type: 'geojson',
            data: createFeatures(this.opts.stations)
          },
          paint: {
            'circle-radius': 6,
            'circle-color': {
              property: 'trend',
              type: 'interval',
              stops: scale
            }
          }
        })

        map.on('click', 'stations_small', showPopup)
        map.on('click', 'stations_large', showPopup)

        // Localize map labels
        let lang = this.i18n.getLocale()
        lang = lang !== 'ko' ? lang : 'en'
        map.addControl(new MapboxglLanguage({
          defaultLanguage: lang,
          excludedLayerIds: ['port-cities-west-lg', 'port-cities-east-lg', 'port-cities-west-sm', 'port-cities-east-sm']
        }))

        // Disable map rotation using right click + drag
        map.dragRotate.disable()

        // Disable map rotation using touch rotation gesture
        map.touchZoomRotate.disableRotation()

        // Change the cursor to a pointer when the mouse is over the stations layer.
        map.on('mouseenter', 'stations_large', () => {
          map.getCanvas().style.cursor = 'pointer'
        })

        // Change it back to a pointer when it leaves.
        map.on('mouseleave', 'stations_large', () => {
          map.getCanvas().style.cursor = ''
        })
      })

      return map
    }

  </script>
</sealevel-explorer-map>
