<sealevel-scrolly>

  <sealevel-scrolly-map />

  <sealevel-scrolly-intro id="intro" locale={locale} />

  <article class="scrolly__article">

    <sealevel-scrolly-main id="main" />

    <div class="scrolly__main__world" id="world"></div>

    <sealevel-scrolly-info id="info" />

    <div class="container">
      <sealevel-scrolly-content steps={steps} />
    </div>

  </article>

  <sealevel-scrolly-outro id="outro" locale={locale} />

  <nav class="scrolly__nav" data-gumshoe-header>
    <ul data-gumshoe>
      <li class="scrolly__nav__item">
        <a class="scrolly__nav__link" href="#intro">
          <b>{i18n.t('scrolly.steps.intro')}</b>
        </a>
      </li>
      <li class="scrolly__nav__item scrolly__nav__item--hidden">
        <a class="scrolly__nav__link" href="#main">
          <b>{i18n.t('scrolly.steps.main')}</b>
        </a>
      </li>
      <li class="scrolly__nav__item scrolly__nav__item--hidden">
        <a class="scrolly__nav__link" href="#world">
          <b>{i18n.t('scrolly.steps.world')}</b>
        </a>
      </li>
      <li class="scrolly__nav__item">
        <a class="scrolly__nav__link" href="#info">
          <b>{i18n.t('scrolly.steps.info')}</b>
        </a>
      </li>
      <li class="scrolly__nav__item" each={step in steps}>
        <a class="scrolly__nav__link" href="#{step}">
          <b>{i18n.t('scrolly.steps.' + step)}</b>
        </a>
      </li>
    </ul>
  </nav>

  <script type="text/babel">
    import _ from 'lodash'
    import gumshoe from 'gumshoe'
    import smoothScroll from 'smooth-scroll'
    import { setStep } from '../../actions/navigation'
    import { STEPS } from '../../routes/'
    import './scrolly-intro.tag'
    import './scrolly-main.tag'
    import './scrolly-info.tag'
    import './scrolly-content.tag'
    import './scrolly-outro.tag'
    import './scrolly-map.tag'

    const routeTo = (event) => {
      const active = event && event.target.id
      const language = this.i18n.getLocale()
      if (active) {
        this.i18n.setLocale(language)
        this.store.dispatch(setStep(active))
        this.root.className = `scrolly--${active}-active`
      }
    }

    const initNavigation = () => {
      smoothScroll('a[href*="#main"]')

      gumshoe.init({
        offset: 0,
        container: window,
        activeClass: 'scrolly__nav__link--active',
        callback: routeTo,
        scrollDelay: false
      })
    }

    // Make steps available in template:
    this.steps = STEPS

    this.on('mount', () => {
      // Defer because the navigation depends on the DOM being rendered
      _.defer(initNavigation)
    })

  </script>

</sealevel-scrolly>
