<sealevel-explorer-station>

  <h1 class="explorer__title">{ opts.station.location }</h1>

  <p>{ opts.station.country_code }</p>

  <sealevel-linechart chartdata="{ this.opts.tides }"></sealevel-linechart>

  <h4>Additional Information on { opts.station.country_name }</h4>

  <p>CO2 emissions: <b>{ opts.station.co2_emissions } tons per capita</b></p>

  <p>Population: <b>{ (opts.station.total_population2010_sum).toLocaleString('en-US', { maximumSignificantDigits: 3 }) }</b></p>

  <p>People living in coastal areas: <b>{ opts.station.coastal_population2010_sum }</b></p>

  <script type="text/babel">
    import '../linechart.tag'

    this.on('update', () => {
      console.log('STATION CONTEXT', this.opts)

      if (this.opts.station) {
        const getYear = new Date(this.opts.station.tideData[0].timestamp)
        this.year = getYear.getFullYear()

        this.rise = opts.station.trend > 0 ? 'Rise of ' : 'Fall of '
      }
    })
  </script>

</sealevel-explorer-station>
