<sealevel-app>
  <sealevel-map onmarkerclick="{ routeToStationDetails }" center="{ center }"
    active="{ activeStep }" animationdata="{ state.animationData }" options="{ opts }"
    steps="{ steps }"></sealevel-map>

  <sealevel-details if="{ state.currentStation }" oncloseclick="{ routeToStationOverview }"
    station="{ state.currentStation }"></sealevel-details>

  <sealevel-navigation steps="{ steps }" active="{ activeStep }"></sealevel-navigation>

  <script type="text/babel">
    import route from 'riot-route'
    import {
      loadExplorerData,
      showStationDetails,
      hideStationDetails,
      loadAnimationData
    } from '../actions'

    const store = this.opts.store

    this.on('mount', () => {
      store.dispatch(loadAnimationData())
    })

    store.subscribe(() => {
      this.update({ state: store.getState() })
    })

    this.steps = [
      '',
      'experimental-animation-1',
      'experimental-animation-2'
    ]

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
      store.dispatch(hideStationDetails())
    })

    route('stations/*', id => {
      store.dispatch(loadExplorerData())
      store.dispatch(showStationDetails(id))
    })

    route.start(true)
  </script>
</sealevel-app>
