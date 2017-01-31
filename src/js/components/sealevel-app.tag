<sealevel-app>
  <sealevel-map onmarkerclick="{ routeToStationDetails }" center="{ center }"
    active="{ activeStep }" options="{ opts }" steps="{ steps }"></sealevel-map>

  <sealevel-details if="{ currentStation }" oncloseclick="{ routeToStationOverview }"
    station="{ currentStation }"></sealevel-details>

  <sealevel-navigation steps="{ steps }" active="{ activeStep }"></sealevel-navigation>

  <script type="text/babel">
    import route from 'riot-route'

    this.currentStation = null

    this.steps = [
      '',
      'experimental-animation-1',
      'experimental-animation-2'
    ]

    this.findStation = (data, id) => {
      return data.find(({ID}) => ID.toString() === id.toString())
    }

    this.showDetailsForStation = (id) => {
      const currentStation = this.findStation(opts.explorerData, id)
      this.update({ currentStation })
    }

    this.hideDetails = () => {
      this.update({ currentStation: null })
    }

    this.routeToStationDetails = (id) => {
      route(`stations/${id}`)
    }

    this.routeToStationOverview = () => {
      route('stations')
    }

    route(slug => {
      const activeStep = this.steps.indexOf(slug)
      if (activeStep >= 0) {
        this.update({ activeStep })
      }
    })

    route('stations', () => {
      this.hideDetails()
    })

    route('stations/*', id => {
      this.showDetailsForStation(id)
    })

    route.start(true)
  </script>
</sealevel-app>
