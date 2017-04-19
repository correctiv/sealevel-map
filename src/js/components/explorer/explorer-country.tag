<sealevel-explorer-country>

  <h2 class="explorer__title">{ opts.country }</h2>

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
      console.log(this.opts.stations)
    })

  </script>

</sealevel-explorer-country>
