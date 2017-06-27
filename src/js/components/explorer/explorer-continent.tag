<sealevel-explorer-continent>

  <h2 class="explorer__title">
    { i18n.t('explorer.continents.' + opts.continent) }
  </h2>

  <p>Afrikas Küsten sind weltweit am wenigsten vorbereitet auf die Fluten. Deswegen werden die Menschen an den Küsten Sansibars, Tansanias oder Marokko viel weniger geschützt als in den industriellen Staaten. Denn dort, wo Schulen und Krankenhäuser fehlen, bleibt wenig Zeit und Geld für den Klimawandel. Dabei werden laut Prognosen in den kommenden Jahren rund 16 Millionen Menschen von den Küsten vertrieben werden. Allein Südafrika ist gerade dabei, Dämme zu errichten und sein Volk ins Inland umzusiedeln. </p>

  <ul class="entries">
    <li each={ country in opts.countries } >
      <a href={ route(country) }>
        <h3 class="entries__title">
          { country }
        </h3>
        <p class="entries__description" if={ stationCount && stationCount[country] }>
          { i18n.t('explorer.num_stations', stationCount[country]) }
        </p>
      </a>
    </li>
  </ul>

  <script type="text/babel">
    import _ from 'lodash'

    this.on('update', () => {
      this.stationCount = _.countBy(this.opts.stations, 'country_code')
    })

    this.route = (id) => opts.pathToCountry(this.i18n.getLocale(), id)
  </script>

</sealevel-explorer-continent>
