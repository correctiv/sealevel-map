<sealevel-explorer-country>
  <h2 class="explorer__title">{ i18n.t('explorer.countries.' + opts.country) }</h2>

  <p>{ this.i18n.t('explorer.emissions_desc', descriptionData) }</p>

  <p>{ this.i18n.t('explorer.risk_desc', descriptionData) }</p>

  <ul class="entries">
    <li each={ station in opts.stations }>
      <a href={ route(station.id) }>
        <h4 class="entries__title">
          { station.location }
        </h4>
        <p class="entries__description">
          { station.trend_1985_2015 }
        </p>
      </a>
    </li>
  </ul>

  <script type="text/babel">
    this.route = (id) => opts.pathToStation(this.i18n.getLocale(), id)

    this.on('update', () => {
      const locale = this.i18n.getLocale()
      const station = this.opts.stations[0]
      const coastPop = station.coastal_population2010_sum
      const totalPop = station.total_population2010_sum

      this.descriptionData = {
        country: this.i18n.t('explorer.countries.' + station.country),
        coastal_population_percent: Math.round(coastPop * 100 / totalPop),
        c02_emissions: Number(station.c02_emissions).toLocaleString(locale)
      }
    })

  </script>

</sealevel-explorer-country>
