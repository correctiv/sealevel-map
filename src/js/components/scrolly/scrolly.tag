<sealevel-scrolly>

  <sealevel-scrolly-intro
    active={introActive}
    locale={locale}
    first-step={steps[0] && steps[0].id}
  />

  <article
    class="scrolly__article"
    id="article"
    ref="article"
  />

  <nav class="scrolly__nav" data-gumshoe-header>
    <ul data-gumshoe>
      <li each={ steps }>
        <a href="#{ id }">{ title }</a>
      </li>
    </ul>
  </nav>

  <script type="text/babel">
    import route from 'riot-route'
    import _ from 'lodash'
    import gumshoe from 'gumshoe'
    import './scrolly-intro.tag'
    import { STEPS } from '../../routes/'
    import { setStep } from '../../actions/navigation'
    import content from '../../../en.md'

    this.steps = []

    const getSteps = (article) => {
      return _.map(article.querySelectorAll('[id]'), element => ({
        id: element.id,
        title: element.textContent
      }))
    }

    this.on('route', (locale, anchor) => {
      this.steps = getSteps(this.refs.article)
      this.locale = locale
      this.refs.article.innerHTML = content

      gumshoe.init({
        container: window,
        callback: (event) => {
          const activeStep = event && event.target.id
          if (activeStep !== this.activeStep) {
            this.update({ activeStep })
          }
        }
      })

      // Toggle intro
      this.update({ introActive: anchor === 'start' })
    })

    this.on('update', update => {
      if (this.activeStep) {
        route(`/${this.locale}/#${this.activeStep}`)
      }
    })

    // initialize routes for main navigation:
    _.forEach(STEPS, slug => {
      route(`*/#${slug}`, () => {
        this.store.dispatch(setStep(slug))
        this.update({ introActive: false })
      })
    })

    route.exec()

  </script>

</sealevel-scrolly>
