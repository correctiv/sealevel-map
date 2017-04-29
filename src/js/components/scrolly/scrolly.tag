<sealevel-scrolly>

  <sealevel-scrolly-intro
    active={state.activeStep === 'start'}
    locale={locale}
  />

  <article class="scrolly__article" id="article">
    <header class="scrolly__header">
      <h1 class="scrolly__title">
        { i18n.t('scrolly.title') }
      </h1>
      <p class="scrolly__lead">
        { i18n.t('scrolly.lead') }
      </p>
    </header>

    <div ref="container"></div>
  </article>

  <nav class="scrolly__nav" data-gumshoe-header>
    <ul data-gumshoe>
      <li each={ steps }>
        <a class="scrolly__nav__link" href="#{ id }">{ title }</a>
      </li>
    </ul>
  </nav>

  <script type="text/babel">
    import route from 'riot-route'
    import _ from 'lodash'
    import gumshoe from 'gumshoe'
    import './scrolly-intro.tag'
    import { setStep } from '../../actions/navigation'
    import content from '../../../en.md'

    const getSteps = (article) => {
      return _.map(article.querySelectorAll('[id]'), element => ({
        id: element.id,
        title: element.textContent
      }))
    }

    const initContent = (language) => {
      this.refs.container.innerHTML = content
      this.steps = getSteps(this.refs.container)

      _.defer(gumshoe.init, {
        container: window,
        activeClass: 'scrolly__nav__link--active',
        callback: (event) => {
          const active = event && event.target.id
          if (active && active !== this.state.activeStep) {
            route(`${language}/#${active}`)
          }
        }
      })
    }

    this.state = {
      activeStep: null
    }

    this.on('route', (language, anchor) => {
      // if (language !== i18n.getLanguage()) {
      this.i18n.setLocale(language)
      initContent(language)
      // }

      if (anchor !== this.state.activeStep) {
        this.store.dispatch(setStep(anchor))
      }

      // Subscribe to global redux state:
      this.subscribe(({ navigation }) => {
        this.update({ state: navigation })
      })
    })

  </script>

</sealevel-scrolly>
