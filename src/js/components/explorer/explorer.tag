<sealevel-explorer>

  <sealevel-explorer-map
    if={ state.items }
    stations={ state.items }
  />

  <div class="explorer-panel">
    <sealevel-explorer-breadcrumbs
      continent={ state.continent || getContinentForCountry(state.country) }
      country={ state.country }
      station={ state.station }
      routes={ routes }
    />

    <sealevel-explorer-overview
      if={ !state.station && !state.continent && !state.country }
      stations={ state.items }
      path-to-continent={ routes.continent }
    />

    <sealevel-explorer-continent
      if={ state.continent }
      continent={ state.continent }
      countries={ getCountriesForContinent(state.continent) }
      stations={ state.items }
      path-to-country={ routes.country }
    />

    <sealevel-explorer-country
      if={ state.country }
      country={ state.country }
      stations={ getStationsForCountry(state.country) }
      path-to-station={ routes.station }
    />

    <sealevel-explorer-station
      if={ state.station }
      station={ getStationContext(state.station.ID) }
      tides={ state.station.tideData }
    />
  </div>

  <script type="text/babel">
    import _ from 'lodash'
    import route from 'riot-route'
    import * as routes from '../../routes/'
    import { requestStationDetails, requestStationList } from '../../actions/explorer'
    import { setStep } from '../../actions/navigation'
    import './explorer-map.tag'
    import './explorer-breadcrumbs.tag'
    import './explorer-overview.tag'
    import './explorer-country.tag'
    import './explorer-continent.tag'
    import './explorer-station.tag'

    this.routes = routes
    this.state = this.store.getState().explorer

    this.on('route', (locale) => {
      // Set locale
      this.i18n.setLocale(locale)

      // Subscribe to global redux state:
      this.subscribe(({ explorer }) => {
        this.update({ state: explorer })
      })
    })

    route('*/explore/stations/*', (locale, id) => {
      this.dispatch(requestStationList())
      this.dispatch(requestStationDetails(id))
      this.dispatch(setStep('explore'))
    })

    route('*/explore/countries/*', (locale, id) => {
      this.dispatch(requestStationList({ country: id }))
    })

    route('*/explore/*', (locale, id) => {
      this.dispatch(requestStationList({ continent: id }))
    })

    route('*/explore', (locale, id) => {
      this.dispatch(requestStationList())
    })

    route.exec()

    this.getStationContext = stationId => (
      _.find(this.state.items, ({ id }) => id === stationId.toString())
    )

    this.getContinentForCountry = id => {
      const sample = _.find(this.state.items, station => station.country_code === id)
      return sample && _.findKey(this.continents, _.partial(_.isEqual, sample.continent))
    }

    this.getCountriesForContinent = id => (
      _(this.state.items)
        .filter(station => station.continent === id)
        .map('country_code')
        .uniq()
        .sort()
        .value()
    )

    this.getStationsForCountry = id => (
      _(this.state.items)
        .filter(station => station.country_code === id)
        .sortBy('location')
        .value()
    )

  </script>

</sealevel-explorer>
