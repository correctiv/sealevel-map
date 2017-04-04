<sealevel-scrolly>

  <sealevel-scrolly-intro  />

  <script type="text/babel">
    import route from 'riot-route'
    import _ from 'lodash'
    import './scrolly-intro.tag'
    import { STEPS } from '../../routes/'
    import { setStep } from '../../actions/navigation'

    // initialize routes for main navigation:
    _.forEach(STEPS, slug => {
      route(slug, () => {
        console.log('show step', slug)
        this.store.dispatch(setStep(slug))
      })
    })

    route('/', id => {
      console.log('show intro')
    })

    route.exec()

  </script>

</sealevel-scrolly>
