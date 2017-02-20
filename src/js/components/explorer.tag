<sealevel-explorer>

  <sealevel-explorer-overview
    if={ !opts.state.station }
    on-continent-select={ opts.routes.routeToContinent }
    data={ opts.state.state }
  />

  <sealevel-explorer-continent
    if={ opts.state.continent }
    continent={ opts.state.continent }
    countries={ countriesForContinent(opts.state.continent) }
    path-to-country={ opts.routes.country }
  />

  <sealevel-explorer-country
    if={ opts.state.country }
    country={ opts.state.country }
    stations={ stationsForCountry(opts.state.country) }
    path-to-station={ opts.routes.station }
  />

  <sealevel-explorer-details
    if={ opts.state.station }
    station={ opts.state.station }
    path-to-country={ opts.routes.country }
  />

  <script type="text/babel">
    import _ from 'lodash'

    const CONTINENTS = {
      'africa': 'Africa',
      'north-america': 'North America',
      'south-america': 'South America',
      'asia': 'Asia',
      'europe': 'Europe',
      'oceania': 'Oceania'
    }

    this.countriesForContinent = id => (
      _(this.opts.state.items)
        .filter(station => station.continent === CONTINENTS[id])
        .map('country')
        .uniq()
        .sort()
        .value()
    )

    this.stationsForCountry = id => (
      _(this.opts.state.items)
        .filter(station => station.country === id)
        .sortBy('location')
        .value()
    )
  </script>

</sealevel-explorer>
