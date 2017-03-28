<sealevel-app>

  <sealevel-map
    routes={ routes }
    center={ center }
    state={ state }
    options={ opts }
  />

  <sealevel-navigation
    active={ state.navigation.activeStep }
    steps={ routes.STEPS }
  />

  <sealevel-explorer
    state={ state.explorer }
    routes={ routes }
  />

  <script type="text/babel">
    import { fetchAnimationDataIfNeeded } from '../actions/animation'
    import * as routes from '../routes/'

    const store = this.opts.store
    this.routes = routes
    this.state = store.getState()

    // Start router:
    routes.startRouting(store)

    // Fetch data:
    store.dispatch(fetchAnimationDataIfNeeded())

    // Subscribe to global redux state:
    store.subscribe(() => {
      this.update({ state: store.getState() })
    })

  </script>
</sealevel-app>
