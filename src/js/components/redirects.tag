<sealevel-redirects>

  <h2>Not found</h2>

  <script type='text/babel'>
    import route from 'riot-route'
    import * as routes from '../routes/'

    // index route (German by default)
    route('/', () => routes.routeToIntro('de'))

    // language versions
    route('de', () => routes.routeToIntro('de'))
    route('fr', () => routes.routeToIntro('fr'))
    route('en', () => routes.routeToIntro('en'))

    route.exec()
  </script>

</sealevel-redirects>
