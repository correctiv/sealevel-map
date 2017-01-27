<sealevel-app>
  <sealevel-map onmarkerclick="{ handleMarkerClick }" center="{ center }"
    active="{ activeStep }" options="{ opts }" steps="{ steps }"></sealevel-map>

  <sealevel-details if="{ currentStation }" oncloseclick="{ handleCloseClick }"
    station="{ currentStation }"></sealevel-details>

  <sealevel-navigation steps="{ steps }" active="{ activeStep }"></sealevel-navigation>

  <script type="text/babel">
    import route from 'riot-route'

    this.currentStation = null

    this.activeStep = 0

    this.steps = [
      'foo',
      'bar',
      'baz',
      'lorem-ipsum',
      'dolor-sit-amet'
    ]

    this.handleMarkerClick = (id) => {
      const currentStation = findStation(opts.items, id)
      this.update({ currentStation })
    }

    this.handleCloseClick = () => {
      this.update({ currentStation: null })
    }

    route(slug => {
      const activeStep = this.steps.indexOf(slug)
      this.update({ activeStep })
    })

    route.start(true)

    function findStation (data, idToLookFor) {
      return data.filter(station => station.ID === idToLookFor)[0]
    }
  </script>
</sealevel-app>
