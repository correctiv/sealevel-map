<sealevel-app>
  <sealevel-map onmarkerclick="{ routeToStationDetails }" center="{ center }"
    active="{ activeStep }" options="{ opts }" steps="{ steps }"></sealevel-map>

  <sealevel-details if="{ state.currentStation }" oncloseclick="{ routeToStationOverview }"
    station="{ state.currentStation }"></sealevel-details>

  <sealevel-navigation steps="{ steps }" active="{ activeStep }"></sealevel-navigation>

  <script type="text/babel">
    import route from 'riot-route'
    import { loadExplorerData, showStationDetails } from '../actions'

    const store = this.opts.store

    this.on('mount', () => {
      store.dispatch(loadExplorerData())
    })

    store.subscribe(() => {
      this.state = store.getState()
      this.update()
    })

    this.steps = [
      '',
      'experimental-animation-1',
      'experimental-animation-2'
    ]

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
      store.dispatch(showStationDetails(id))
    })

    route.start(true)
  </script>
</sealevel-app>
