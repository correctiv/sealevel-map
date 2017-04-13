<sealevel-explorer>

  <sealevel-explorer-overview
    if={ !state.station && !state.continent && !state.country }
    stations={ state.items }
    continents={ continents }
    path-to-continent={ routes.continent }
  />

  <sealevel-explorer-continent
    continent={ state.continent }
    countries={ countriesForContinent(state.continent) }
    path-to-country={ routes.country }
  />

  <sealevel-explorer-country
    if={ state.country }
    country={ state.country }
    stations={ stationsForCountry(state.country) }
    path-to-station={ routes.station }
  />

  <sealevel-explorer-details
    if={ state.station }
    station={ state.station }
    path-to-country={ routes.country }
  />

  <script type="text/babel">
    import _ from 'lodash'
    import route from 'riot-route'
    import * as routes from '../../routes/'
    import { requestStationDetails, requestStationList } from '../../actions/explorer'
    import { setStep } from '../../actions/navigation'
    import './explorer-overview.tag'
    import './explorer-country.tag'
    import './explorer-continent.tag'
    import './explorer-details.tag'

    this.continents = {
      'africa': 'Africa',
      'north-america': 'North America',
      'south-america': 'South America',
      'asia': 'Asia',
      'europe': 'Europe',
      'oceania': 'Oceania'
    }

    route('*/explore/stations/*', (locale, id) => {
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

    this.countriesForContinent = id => (
      _(this.state.items)
        .filter(station => station.continent === this.continents[id])
        .map('country')
        .uniq()
        .sort()
        .value()
    )

    this.stationsForCountry = id => (
      _(this.state.items)
        .filter(station => station.country === id)
        .sortBy('location')
        .value()
    )

  </script>

</sealevel-explorer>
