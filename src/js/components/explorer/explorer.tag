<sealevel-explorer>

  <sealevel-explorer-map
    if={ state.items && isLargeViewport() }
    stations={ state.items }
    country={ state.country }
    continent={ state.continent }
    station={ state.station }
    route-to-station={ routes.routeToStation }
  />

  <div class="explorer-panel">
    <sealevel-explorer-breadcrumbs
      if={ state.station || state.continent || state.country }
      continent={ state.continent || getContinentForCountry(state.country) }
      country={ state.country || getCountryForStation(state.station) }
      station={ getStationContext(state.station) }
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
      if={ state.station && state.items }
      station={ getStationContext(state.station) }
      tides={ getTidesForStation(state.station) }
      path-to-country={ routes.country }
    />

    <a class="explorer__download" href="{ i18n.t('explorer.download_link') }" target="_blank">
      <h4 class="explorer__download__title">
        { i18n.t('explorer.download_text') }
      </h4>
      <span class="explorer__download__meta">
        { i18n.t('explorer.download_meta') }
      </span>
    </a>

    <div class="explorer__credits">
      <h4>{ i18n.t('credits.title') }</h4>
      <ul>
        <li>{ i18n.t('credits.developer') }</li>
        <li>{ i18n.t('credits.designer') }</li>
        <li>{ i18n.t('credits.editor') }</li>
      </ul>
    </div>
  </div>

  <script type="text/babel">
    import _ from 'lodash'
    import route from 'riot-route'
    import * as routes from '../../routes/'
    import { requestStationList } from '../../actions/explorer'
    import './explorer-map.tag'
    import './explorer-breadcrumbs.tag'
    import './explorer-overview.tag'
    import './explorer-country.tag'
    import './explorer-continent.tag'
    import './explorer-station.tag'

    const MOBILE_BREAKPOINT = 480

    this.routes = routes
    this.state = this.store.getState().explorer

    // Subscribe to global redux state:
    this.subscribe(({ explorer }) => {
      this.update({ state: explorer })
    })

    route('*/explore/stations/*', (locale, id) => {
      this.dispatch(requestStationList({ station: id, locale}))
    })

    route('*/explore/countries/*', (locale, id) => {
      this.dispatch(requestStationList({ country: id, locale }))
    })

    route('*/explore/start', (locale) => {
      this.dispatch(requestStationList({ locale }))
    })

    route('*/explore/*', (locale, id) => {
      this.dispatch(requestStationList({ continent: id, locale }))
    })

    route('*/explore/', (locale) => {
      this.dispatch(requestStationList({ locale }))
    })

    route.exec()

    this.on('route', (locale) => {
      this.i18n.setLocale(locale)
    })

    this.isLargeViewport = () => (
      document.documentElement.clientWidth >= MOBILE_BREAKPOINT
    )

    this.getStationContext = stationId => (
      _.find(this.state.items, ({ id }) => id === stationId)
    )

    this.getContinentForCountry = id => {
      const item = _.find(this.state.items, ({ country }) => country === id)
      return item && item.continent
    }

    this.getCountriesForContinent = id => (
      this.state.items && _(this.state.items)
        .filter(station => station.continent === id)
        .map('country')
        .uniq()
        .sort()
        .value()
    )

    this.getStationsForCountry = id => (
      this.state.items && _(this.state.items)
        .filter(station => station.country === id)
        .sortBy('location')
        .value()
    )

    this.getCountryForStation = id => {
      const item = _.find(this.state.items, station => station.id === id)
      return item && item.country
    }

    this.getTidesForStation = id => (
      this.state.tides && this.state.tides[id]
    )

    window.addEventListener('deviceorientation', () => this.update())
    window.addEventListener('resize', () => this.update())

  </script>

</sealevel-explorer>
