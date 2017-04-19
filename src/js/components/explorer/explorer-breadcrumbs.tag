<sealevel-explorer-breadcrumbs>

  <ul class="breadcrumbs">
    <li if={continent}>
      <a href={ pathToExplorer() }>
        { i18n.t('explorer.start') }
      </a>
    </li>
    <li if={continent}>
      <a href={ pathToContinent(continent) }>
        { i18n.t('explorer.continents.' + continent) }
      </a>
    </li>
    <li if={country}>
      <a href={ pathToCountry(country) }>
        { i18n.t('explorer.countries.' + country) }
      </a>
    </li>
    <li if={station}>
      <a href={ pathToStation(station.ID) }>
        { station.location }
      </a>
    </li>
  </ul>

  <script type="text/babel">
    this.on('update', () => {
      const { station, country, continent } = this.opts
      this.country = station && station.country || country
      this.continent = station && station.continent || continent
      this.station = station
    })

    this.pathToExplorer = () => (
      opts.routes.explorer(this.i18n.getLocale())
    )

    this.pathToContinent = id => (
      opts.routes.continent(this.i18n.getLocale(), id)
    )

    this.pathToCountry = id => (
      opts.routes.country(this.i18n.getLocale(), id)
    )

    this.pathToStation = id => (
      opts.routes.station(this.i18n.getLocale(), id)
    )
  </script>

</sealevel-explorer-breadcrumbs>
