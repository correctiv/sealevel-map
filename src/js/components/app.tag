<sealevel-app>

  <router>
    <route path="explore..">
      <sealevel-explorer />
    </route>
  </router>

  <sealevel-map options={ opts } />

  <sealevel-navigation
    active={ store.getState().navigation.activeStep }
    steps={ store.getState().STEPS }
  />

  <script type="text/babel">
    import 'riot-route/tag'
    import * as routes from '../routes/'

    // Start router:
    routes.startRouting(this.store)
  </script>

</sealevel-app>
