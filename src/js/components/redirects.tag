<sealevel-redirects>

  <h2>Not found</h2>

  <script type='text/babel'>
    import route from 'riot-route'
    import * as routes from '../routes/'

    route('/', () => routes.routeToIntro('de'))
    route('de', () => routes.routeToIntro('de'))
    route('fr', () => routes.routeToIntro('fr'))
    route.exec()
  </script>

</sealevel-redirects>
