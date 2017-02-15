<sealevel-explorer-overview>

    <div class="sealevel__details">

      <select onchange={ continentSelected }>
        <option  each={ continent in continents } value={ continent } selected={ continent === selected }>
          { continent }
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

      <ul if={ continent }>
        { continent }
      </ul>

    </div>

    <script type="text/babel">
      import _ from 'lodash'

      const CONTINENTS = [
        'Africa',
        'North America',
        'South America',
        'Asia',
        'Europe',
        'Oceania'
      ]

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
          this.continent = data.continent
        }
      })

      this.getCountryRoute = (id) => `#countries/${id}`

      this.continentSelected = (event) => {
        this.currentContinent = event.target.value
      }
    </script>


</sealevel-explorer-overview>
