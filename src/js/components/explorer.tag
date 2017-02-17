<sealevel-explorer>

  <sealevel-explorer-overview
    if={ !state.station }
    on-continent-select={ opts.routes.routeToContinent }
    data={ state }
  />

  <sealevel-explorer-continent
    if={ continent }
    continent={ continent }
    countries={ stationsByContinent[continent] }
    path-to-country={ opts.routes.country }
  />

  <div if={ country }>
    { country }
  </div>

  <sealevel-explorer-details
    if={ state.station }
    station={ state.station }
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

    const groupByContinent = (stations) => (
      _(stations)
        .groupBy('continent')
        .mapValues(continent => _.groupBy(continent, 'country'))
        .value()

    this.on('mount', () => {
      this.continents = CONTINENTS
    })

    this.on('update', () => {
      const data = this.opts.state
      if (data && data.items) {
        this.stationsByContinent = groupByContinent(data.items)
        this.country = data.country
        this.continent = CONTINENTS[data.continent]
      }
    })

    this.on('update', () => {
      this.state = opts.state
    })

  </script>

</sealevel-explorer>
