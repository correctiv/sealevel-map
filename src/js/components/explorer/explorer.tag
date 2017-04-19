<sealevel-explorer class="explorer">

  <sealevel-explorer-breadcrumbs
    continent={ state.continent || continentForCountry(state.country) }
    country={ state.country }
    station={ state.station }
    routes={ routes }
  />

  <sealevel-explorer-overview
    if={ !state.station && !state.continent && !state.country }
    continents={ continents }
    stations={ state.items }
    path-to-continent={ routes.continent }
  />

  <sealevel-explorer-continent
    if={ state.continent }
    continent={ state.continent }
    countries={ countriesForContinent(state.continent) }
    stations={ state.items }
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
    import './explorer-breadcrumbs.tag'
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

    this.continentForCountry = id => {
      const sample = _.find(this.state.items, station => station.country_code === id)
      return sample && _.findKey(this.continents, _.partial(_.isEqual, sample.continent))
    }

    this.countriesForContinent = id => (
      _(this.state.items)
        .filter(station => station.continent === this.continents[id])
        .map('country_code')
        .uniq()
        .sort()
        .value()
    )

    this.stationsForCountry = id => (
      _(this.state.items)
        .filter(station => station.country_code === id)
        .sortBy('location')
        .value()
    )

  </script>

</sealevel-explorer>
