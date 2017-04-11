<sealevel-explorer-country>

  <h2>{ opts.country }</h2>

  <ul>
    <li each={ station in opts.stations } >
      <a href={ route(station.ID) }>{ station.location }</a>
    </li>
  </ul>

  <script type="text/babel">
    this.route = (id) => opts.pathToStation(opts.locale, id)
  </script>

</sealevel-explorer-country>
