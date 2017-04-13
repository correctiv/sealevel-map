<sealevel-scrolly>

  <sealevel-scrolly-intro
    active={state.activeStep === 'start'}
    locale={locale}
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
    import { setStep } from '../../actions/navigation'
    import content from '../../../en.md'

    const getSteps = (article) => {
      return _.map(article.querySelectorAll('[id]'), element => ({
        id: element.id,
        title: element.textContent
      }))
    }

    const initContent = (language) => {
      this.refs.article.innerHTML = content
      this.steps = getSteps(this.refs.article)

      _.defer(gumshoe.init, {
        container: window,
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

    this.on('mount', () => {
      // console.log('state', this.state)
      // debugger
      // riot.mixin('i18n', i18n, true)
      // i18n.setLanguage('de')
      // i18n.localise('Hello') // -> Hello
    })

  </script>

</sealevel-scrolly>
