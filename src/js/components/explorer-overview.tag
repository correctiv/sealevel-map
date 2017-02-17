<sealevel-explorer-overview>

  <select onchange={ continentSelected }>
    <option each={ key, name in continents }
      value={ key } selected={ continent === name }>
      { name }
    </option>
  </select>

  <ul if={ !country && !continent }>
    <li each={ continent, countries in stationsByContinent } >
      <h3>{ continent }</h3>
      <ul>
        <li each={ country, data in countries }>
          <a href={ getCountryRoute(country) }>{ country }</a>
        </li>
      </ul>
    </li>
  </ul>

  <ul if={ country }>
    { country }
  </ul>

  <ul if={ stationsByContinent[continent] }>
    <li each={ country, stations in stationsByContinent[continent] } >
      <h3>{ country }</h3>
      <ul>
        <li each={ station in stations }>
          <a href={ getStationRoute(station.ID) }>{ station.location }</a>
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
