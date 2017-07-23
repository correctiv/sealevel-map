<sealevel-explorer-station>

  <h1 class="explorer__title">{ opts.station.location }</h1>

  <p>{ i18n.t('explorer.countries.' + opts.station.country) }</p>

  <sealevel-linechart chartdata={ opts.tides } />

  <p>{ stationDesc }</p>

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
        station.last_available_year = year
        station.last_available_value = tide > 0 ? tide : -tide
        this.stationDesc = this.i18n.t(getStationDesc(station.trend_1985_2015), station)
      }
    })
  </script>

</sealevel-explorer-station>
