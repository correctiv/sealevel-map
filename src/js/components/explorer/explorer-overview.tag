<sealevel-explorer-overview>

  <div class="explorer__intro">
    <h2 class="explorer__intro__title">{ i18n.t('explorer.title') }</h2>
    <p>{ i18n.t('explorer.title') }</p>
  </div>

  <h2 class="explorer__title">{ i18n.t('explorer.choose_continent') }</h2>

  <ul class="entries">
    <li each={ stations, slug in continents }>
      <a href={ route(slug) }>
        <h3 class="entries__title">
          { i18n.t('explorer.continents.' + slug) }
        </h3>
        <p class="entries__description">
          { i18n.t('explorer.num_stations', stations.length) }
        </p>
      </a>
    </li>
  </ul>

  <script type="text/babel">
    import _ from 'lodash'

    this.on('update', () => {
      this.continents = _.groupBy(this.opts.stations, 'continent')
    })

    this.route = (slug) => (
      opts.pathToContinent(this.i18n.getLocale(), slug)
    )
  </script>

</sealevel-explorer-overview>
