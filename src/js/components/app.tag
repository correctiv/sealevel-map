<sealevel-app>

  <router>
    <route path="*/explore..">
      <sealevel-explorer />
    </route>
    <route path="*/#*">
      <sealevel-scrolly />
    </route>
    <route path="..">
      <sealevel-redirects />
    </route>
  </router>

  <sealevel-navigation
    active={ store.getState().navigation.activeStep }
    steps={ store.getState().STEPS }
  />

  <script type="text/babel">
    import 'riot-route/tag'
    import './scrolly/scrolly.tag'
    import './explorer/explorer.tag'
    import './redirects.tag'
  </script>

</sealevel-app>
