<sealevel-scrolly>

  <sealevel-scrolly-map />

  <sealevel-scrolly-intro data-step id="intro" locale={locale} />

  <article class="scrolly__article">

    <sealevel-scrolly-main data-step id="main" />

    <div class="scrolly__main__world" data-step id="world"></div>

    <sealevel-scrolly-info data-step id="info" />

    <div class="container">
      <sealevel-scrolly-content steps={steps} />
    </div>

  </article>

  <sealevel-scrolly-outro id="outro" locale={locale} />

  <nav class="scrolly__nav">
    <ul>
      <li class="scrolly__nav__item">
        <a class="scrolly__nav__link {this.activeStep === 'info' && 'scrolly__nav__link--active'}" href="#info">
          <b>{i18n.t('scrolly.steps.info')}</b>
        </a>
      </li>
      <li class="scrolly__nav__item" each={step in steps}>
        <a class="scrolly__nav__link {this.activeStep === step && 'scrolly__nav__link--active'}" href="#{step}">
          <b>{i18n.t('scrolly.steps.' + step)}</b>
        </a>
      </li>
    </ul>
  </nav>

  <script type="text/babel">
    import _ from 'lodash'
    import scrollama from 'scrollama/build/scrollama.js'
    import smoothScroll from 'smooth-scroll'
    import { setStep } from '../../actions/navigation'
    import { STEPS } from '../../routes/'
    import './scrolly-intro.tag'
    import './scrolly-main.tag'
    import './scrolly-info.tag'
    import './scrolly-content.tag'
    import './scrolly-outro.tag'
    import './scrolly-map.tag'

    const routeTo = (activeStep) => {
      const language = this.i18n.getLocale()
      if (activeStep) {
        this.i18n.setLocale(language)
        this.update({ activeStep })
        this.store.dispatch(setStep(activeStep))
        this.root.className = `scrolly--${activeStep}-active`
      }
    }

    const initNavigation = () => {
      smoothScroll('a[href*="#main"]')
      const scroller = scrollama();

      // setup the instance, pass callback functions
      scroller
        .setup({
          step: "[data-step]",
          offset: 1
        })
        .onStepEnter(({ element, index, direction }) => {
          const step = element && element.id
          routeTo(step)
        })
    }

    // Make steps available in template:
    this.steps = STEPS

    this.on('route', (locale) => {
      this.i18n.setLocale(locale)
    })

    this.on('mount', () => {
      // Defer because the navigation depends on the DOM being rendered
      _.defer(initNavigation)
    })

  </script>

</sealevel-scrolly>
