<sealevel-explorer-continent>

  <ul>
    <li each={ country in opts.countries } >
      <a href={ route(country) }>{ country }</a>
      <p if={ stationCount && stationCount[country] }>
        { i18n.t('explorer.num_stations', stationCount[country]) }
      </p>
    </li>
  </ul>

  <script type="text/babel">
    import _ from 'lodash'

    this.on('update', () => {
      this.stationCount = _.countBy(this.opts.stations, 'country')
    })

    this.route = (id) => opts.pathToCountry(this.i18n.getLocale(), id)
  </script>

</sealevel-explorer-continent>
