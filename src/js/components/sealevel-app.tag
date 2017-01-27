<sealevel-app>
  <sealevel-map onmarkerclick="{ handleMarkerClick }" onnextclick="{ showNext }"
    active="{ activeStep }" options="{ opts }" steps="{ steps }"
    canter="{ center }"></sealevel-map>

  <sealevel-details if="{ currentStation }" oncloseclick="{ handleCloseClick }"
    station="{ currentStation }"></sealevel-details>

  <sealevel-navigation steps="{ steps }" active="{ activeStep }"
    onselect="{ showStep }"></sealevel-navigation>

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
      const station = findStation(opts.items, id)
      this.updateStations(station)
    }

    this.handleCloseClick = () => {
      this.update({
        currentStation: null
      })
    }

    this.updateStations = (station) => {
      this.update({
        currentStation: station
      })
    }

    this.showNext = (id) => {
      this.handleMarkerClick(id)
    }

    this.showStep = (stepID) => {
      this.activeStep = stepID
    }

    route(slug => {
      this.update({
        activeStep: this.steps.indexOf(slug)
      })
    })

    route.start(true)

    function findStation (data, idToLookFor) {
      return data.filter(station => station.ID === idToLookFor)[0]
    }
  </script>
</sealevel-app>
