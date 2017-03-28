<sealevel-explorer-overview>

  <select onchange={ continentSelected }>
    <option each={ name, key in continents }
      value={ key } selected={ continent === name }>
      { name }
    </option>
  </select>

  <ul if={ !country && !continent }>
    <li each={ countries, continent in stationsByContinent } >
      <h3>{ continent }</h3>
      <ul>
        <li each={ data, country in countries }>
          <a href={ getCountryRoute(country) }>{ country }</a>
        </li>
      </ul>
    </li>
  </ul>

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

    const groupStationsByContinent = (stations) => {
      return _(stations)
        .groupBy('continent')
        .mapValues(continent => _.groupBy(continent, 'country'))
        .value()
    }

    this.on('mount', () => {
      this.continents = CONTINENTS
    })

    this.on('update', () => {
      const data = this.opts.data
      if (data && data.items) {
        this.stationsByContinent = groupStationsByContinent(data.items)
        this.country = data.country
        this.continent = CONTINENTS[data.continent]
      }
    })

    this.getCountryRoute = (id) => `#countries/${id}`

    this.getStationRoute = (id) => `#stations/${id}`

    this.continentSelected = ({ target }) => {
      this.opts.onContinentSelect(target.value)
    }
  </script>

</sealevel-explorer-overview>
