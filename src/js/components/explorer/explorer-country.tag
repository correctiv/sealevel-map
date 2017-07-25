<sealevel-explorer-country>
  <h2 class="explorer__title">{ i18n.t('explorer.countries.' + opts.country) }</h2>

  <div if={ opts.stations[0].c02_emissions }>
    <p>{ this.i18n.t('explorer.emissions_desc', descriptionData) }</p>
    <p>{ this.i18n.t('explorer.risk_desc', descriptionData) }</p>
  </div>

  <ul class="entries">
    <li each={ station in opts.stations }>
      <a
        href={ route(station.id) }
        class="entries__item {getChangeIndicator(station)}"
      >
        <h4 class="entries__title">
          { station.location }
        </h4>
        <p class="entries__description">
          { this.i18n.t('explorer.sealevel_change', { change: getChangeValue(station) }) }
        </p>
      </a>
    </li>
  </ul>

  <script type="text/babel">
    import _ from 'lodash'

    const SCALE = [
      { threshold: -60, className: 'entries__item--change-lower' },
      { threshold: -15, className: 'entries__item--change-low' },
      { threshold: +15, className: 'entries__item--change-flat' },
      { threshold: +60, className: 'entries__item--change-high' },
      { threshold: Infinity, className: 'entries__item--change-higher' }
    ]

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

    this.getChangeValue = ({ timeseries }) => _.last(timeseries)

    this.getChangeIndicator = (station) => {
      const amplitude = this.getChangeValue(station)
      const scaleItem = _.find(SCALE, ({ threshold }) => amplitude < threshold)
      return scaleItem.className
    }

  </script>

</sealevel-explorer-country>
