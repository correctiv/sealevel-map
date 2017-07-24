<sealevel-scrolly>

  <sealevel-scrolly-map />

  <sealevel-scrolly-intro id="intro" locale={locale} on-more-click={scrollTo} />

  <article class="scrolly__article">

    <sealevel-scrolly-header />

    <div class="container">
      <sealevel-scrolly-content steps={steps} />
    </div>

  </article>

  <nav class="scrolly__nav" data-gumshoe-header>
    <ul data-gumshoe>
      <li>
        <a onclick={scrollTo} class="scrolly__nav__link" href="#intro">Start</a>
      </li>
      <li>
        <a onclick={scrollTo} class="scrolly__nav__link" href="#main">Introduction</a>
      </li>
      <li each={step in steps}>
        <a onclick={scrollTo} class="scrolly__nav__link" href="#{step}">{title}</a>
      </li>
    </ul>
  </nav>

  <script type="text/babel">
    import route from 'riot-route'
    import _ from 'lodash'
    import gumshoe from 'gumshoe'
    import smoothScroll from 'smooth-scroll'
    import { setStep } from '../../actions/navigation'
    import { STEPS } from '../../routes/'
    import './scrolly-intro.tag'
    import './scrolly-header.tag'
    import './scrolly-content.tag'
    import './scrolly-map.tag'

    const routeTo = (event) => {
      const active = event && event.target.id
      const language = this.i18n.getLocale()
      if (active) {
        route(`${language}/#${active}`)
      }
    }

    const initNavigation = () => {
      gumshoe.init({
        container: window,
        activeClass: 'scrolly__nav__link--active',
        callback: routeTo
      })
    }

    // Make steps available in template:
    this.steps = STEPS

    this.scrollTo = ({ target }) => {
      var anchor = this.root.querySelector(target.hash)
      smoothScroll.animateScroll(anchor, null, {
        speed: 1000,
        easing: 'easeOutCubic'
      })
    }

    this.on('route', (language, anchor) => {
      this.i18n.setLocale(language)
      this.store.dispatch(setStep(anchor))
      this.root.className = `scrolly--${anchor}-active`
    })

    this.on('mount', () => {
      // Defer because the navigation depends on the DOM being rendered
      _.defer(initNavigation)
    })

  </script>

</sealevel-scrolly>
