<sealevel-app>
  <sealevel-map onmarkerclick="{ routeToStationDetails }" center="{ center }"
    active="{ state.navigation.activeStep }" animationdata="{ state.animation.items }" options="{ opts }"
    steps="{ steps }"></sealevel-map>

  <sealevel-details if="{ state.explorer.currentStation }" oncloseclick="{ routeToStationOverview }"
    station="{ state.explorer.currentStation }"></sealevel-details>

  <sealevel-explorer-overview data="{ state.explorer }"></sealevel-explorer-overview>

  <sealevel-navigation steps="{ steps }" active="{ activeStep }"></sealevel-navigation>

  <script type="text/babel">
    import route from 'riot-route'
    import { setStep } from '../actions/navigation'
    import { fetchAnimationDataIfNeeded } from '../actions/animation'
    import { requestStationDetails, hideStationDetails, requestStationList } from '../actions/explorer'

    const store = this.opts.store

    this.on('mount', () => {
      store.dispatch(fetchAnimationDataIfNeeded())
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
        store.dispatch(setStep(activeStep))
      }
    })

    route('stations', () => {
      store.dispatch(hideStationDetails())
    })

    route('stations/*', id => {
      store.dispatch(requestStationDetails(id))
    })

    route('countries', () => {
      store.dispatch(requestStationList())
    })

    route.start(true)
  </script>
</sealevel-app>
