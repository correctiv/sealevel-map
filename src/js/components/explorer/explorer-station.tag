<sealevel-explorer-station>

  <h1 class="explorer__title">{ opts.station.location }</h1>

  <sealevel-linechart chartdata={ opts.tides } />

  <p>{ stationDesc }</p>

  <a href={ routeBack(opts.station.country) }>
    { i18n.t('explorer.back') }
    { i18n.t('explorer.countries.' + opts.station.country) }
  </a>

  <script type="text/babel">
    import _ from 'lodash'
    import '../linechart.tag'

    const getStationDesc = (trend) => {
      if (!trend) {
        return 'explorer.station_desc_unclear'
      }
      if (trend > 2) {
        return 'explorer.station_desc_higher'
      }
      if (trend > 0.5) {
        return 'explorer.station_desc_high'
      }
      if (trend > -0.5) {
        return 'explorer.station_desc_flat'
      }
      if (trend > -2) {
        return 'explorer.station_desc_low'
      }
      return 'explorer.station_desc_lower'
    }

    this.on('update', () => {
      const { station, tides } = this.opts

      if (station && tides) {
        const { tide, year } = _.last(tides)
        const tideShort = _.last(station.timeseries)
        station.last_available_year = year
        station.last_available_value_since_beginning = tide > 0 ? tide : -tide
        station.last_available_value = tideShort > 0 ? tideShort : -tideShort

        // different description text for manila
        if (station.id === '145') {
          this.stationDesc = this.i18n.t('explorer.manila')
        } else {
          this.stationDesc = this.i18n.t(getStationDesc(station.trend_1985_2015), station)
        }
      }
    })

    this.routeBack = (id) => opts.pathToCountry(this.i18n.getLocale(), id)
  </script>

</sealevel-explorer-station>
