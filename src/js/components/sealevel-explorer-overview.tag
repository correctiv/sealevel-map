<sealevel-explorer-overview>

    <div class="sealevel__details">

      <select value={ this.component } onchange={ continentSelected }>
        <option  each={ continent in continents } value={ continent } selected={ continent === selected }>
          { continent }
        </option>
      </select>

      <ul>
        <li each={ continent, countries in stationsByContinent } >
          <h3>{ continent }</h3>
          <ul>
            <li each={ country, data in countries }>
              <a href={ getCountryRoute(country) }>{ country }</a>
            </li>
          </ul>
        </li>
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
        this.currentContinent = ''
      })

      this.on('update', () => {
        if (this.opts.data && this.opts.data.items) {
          let stations = this.opts.data.items
          this.stationsByContinent = groupStationsByContinent(stations)
        }
      })

      this.getCountryRoute = (id) => `#countries/${id}`

      this.continentSelected = (event) => {
        this.currentContinent = event.target.value
      }
    </script>


</sealevel-explorer-overview>
