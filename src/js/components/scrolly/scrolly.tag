<sealevel-scrolly>

  <sealevel-scrolly-map />

  <sealevel-scrolly-intro id="intro" locale={locale} />

  <article class="scrolly__article">

    <sealevel-scrolly-header />

    <div class="container">
      <sealevel-scrolly-content steps={steps} />
    </div>

  </article>

  <nav class="scrolly__nav" data-gumshoe-header>
    <ul data-gumshoe>
      <li>
        <a class="scrolly__nav__link" href="#intro">Start</a>
      </li>
      <li>
        <a class="scrolly__nav__link" href="#main">Introduction</a>
      </li>
      <li each={step in steps}>
        <a class="scrolly__nav__link" href="#{step}">{title}</a>
      </li>
    </ul>
  </nav>

  <script type="text/babel">
    import route from 'riot-route'
    import _ from 'lodash'
    import gumshoe from 'gumshoe'
    import { setStep } from '../../actions/navigation'
    import { STEPS } from '../../routes/'
    import './scrolly-intro.tag'
    import './scrolly-header.tag'
    import './scrolly-content.tag'
    import './scrolly-map.tag'

    const initNavigation = (language) => {
      _.defer(gumshoe.init, {
        container: window,
        activeClass: 'scrolly__nav__link--active',
        callback: (event) => {
          const active = event && event.target.id
          if (active) {
            route(`${language}/#${active}`)
          }
        }
      })
    }

    // Make steps available in template:
    this.steps = STEPS

    this.on('route', (language, anchor) => {
      this.i18n.setLocale(language)
      this.store.dispatch(setStep(anchor))
      this.root.className = `scrolly--${anchor}-active`
      initNavigation(language)
    })

  </script>

</sealevel-scrolly>
