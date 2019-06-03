<sealevel-explorer-station>

  <h1 class="explorer__title">{ opts.station.location }</h1>

  <sealevel-linechart
    if={ opts.tides }
    series={ [{ data: opts.tides }] }
  />

  <p if={ stationDesc }>
    { stationDesc }
  </p>

  <sealevel-article-link for={ opts.station.id } />

  <a class="explorer__back-link" href={ routeBack(opts.station.country) }>
    { i18n.t('explorer.back') }
    { i18n.t('explorer.countries.' + opts.station.country) }
  </a>

  <script type="text/babel">
    import _ from 'lodash'
    import '../linechart.tag'
    import '../common/article-link.tag'

    // Basic implementation of Math.sign, which is not widely supported in browsers
    const sign = x => ((x > 0) - (x < 0)) || +x

    const getStationDesc = (trend, tide) => {
      if (!trend) {
        return 'explorer.station_desc_unclear'
      }
      if ((sign(trend) !== sign(tide)) && (trend > 0)) {
        return 'explorer.station_desc_unclear_positive'
      }
      if ((sign(trend) !== sign(tide)) && (trend < 0)) {
        return 'explorer.station_desc_unclear_negative'
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

    this.routeBack = (id) => opts.pathToCountry(this.i18n.getLocale(), id)

    this.on('update', () => {
      const station = this.opts.station
      const tides = this.opts.tides

      if (station && tides) {
        const tide = _.last(tides)
        const year = _.lastIndexOf(tides, tide)
        const tideShort = _.last(station.timeseries)
        station.last_available_year = year
        station.last_available_value_since_beginning = tide > 0 ? tide : -tide
        station.last_available_value = tideShort > 0 ? tideShort : -tideShort

        // different description text for manila
        if (station.id === '145') {
          this.stationDesc = this.i18n.t('explorer.manila')
        } else {
          const stationDesc = getStationDesc(station.trend, tide)
          this.stationDesc = this.i18n.t(stationDesc, station)
        }
      }
    })

  </script>

</sealevel-explorer-station>
