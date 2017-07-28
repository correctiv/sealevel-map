<sealevel-explorer-continent>

  <h2 class="explorer__title">
    { i18n.t('explorer.continents.' + opts.continent) }
  </h2>

  <p>
    { i18n.t('explorer.continent_descriptions.' + opts.continent) }
  </p>

  <sealevel-article-link for={opts.continent} />

  <ul class="entries">
    <li each={ country in opts.countries } >
      <a class="entries__item" href={ route(country) }>
        <h3 class="entries__title">
          { i18n.t('explorer.countries.' + country) }
        </h3>
        <p class="entries__description" if={ stationCount && stationCount[country] }>
          { i18n.t('explorer.num_stations', stationCount[country]) }
        </p>
      </a>
    </li>
  </ul>


  <script type="text/babel">
    import _ from 'lodash'
    import '../common/article-link.tag'

    this.on('update', () => {
      this.stationCount = _.countBy(this.opts.stations, 'country')
    })

    this.route = (id) => opts.pathToCountry(this.i18n.getLocale(), id)
  </script>

</sealevel-explorer-continent>
