<sealevel-explorer>

  <sealevel-explorer-overview
    if={ !state.station }
    on-continent-select={ opts.routes.routeToContinent }
    data={ state }
  />

  <sealevel-explorer-details
    if={ state.station }
    station={ state.station }
  />

  <script type="text/babel">

    this.on('update', () => {
      this.state = opts.state
    })

  </script>

</sealevel-explorer>
