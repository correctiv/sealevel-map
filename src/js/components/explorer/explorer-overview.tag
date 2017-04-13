<sealevel-explorer-overview>

  <h1>{ i18n.t('explorer.title') }</h1>
  <h2>{ i18n.t('explorer.choose_continent') }</h2>

  <ul>
    <li each={ name, slug in opts.continents }>
      <a href={ route(slug) }>
        { i18n.t('explorer.continents.' + slug) }
        <p if={ stationCount && stationCount[name] }>
          { i18n.t('explorer.num_stations', stationCount[name]) }
        </p>
      </a>
    </li>
  </ul>

  <script type="text/babel">
    import _ from 'lodash'

    this.on('update', () => {
      this.stationCount = _.countBy(this.opts.stations, 'continent')
    })

    this.route = (slug) => (
      opts.pathToContinent(this.i18n.getLocale(), slug)
    )

  </script>

  </script>

</sealevel-explorer-overview>
