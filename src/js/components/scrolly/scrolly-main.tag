<sealevel-scrolly-main class="scrolly__main">

  <div class="scrolly__main__wrapper">
    <div class="container">
      <div class="scrolly__main__content">

        <div class="scrolly__main__sidebar">

          <div class="scrolly__main__authors">
            { i18n.t('scrolly.authors') }
            <em>Annika Joeres,</em>
            <em>Simon Jockers,</em>
            <em>Felix Michel</em>
          </div>

          <div class="scrolly__main__partners">
            <h4>{ i18n.t('scrolly.partners') }</h4>
            <a each={ partners } href={ url }>
              <img src={ logo } alt={ title } />
            </a>
          </div>

        </div>

        <p class="scrolly__main__body scrolly__main__body--lead">
          { i18n.t('scrolly.introduction') }
        </p>

        <div class="scrolly__main__body" ref="body"></div>

      </div>
    </div>
  </div>

  <script type="text/babel">
    this.partners = [{
      title: 'Mediapart',
      url: 'https://mediapart.fr',
      logo: require('../../../assets/images/logo-mediapart.svg')
    },
    {
      title: 'TagesWoche',
      url: 'https://tageswoche.ch',
      logo: require('../../../assets/images/logo-tageswoche.svg')
    }]

    this.on('update', () => {
      const lang = this.i18n.getLocale()
      const body = require(`../../../locale/${lang}/main.md`)
      this.refs.body.innerHTML = body
    })
  </script>

</sealevel-scrolly-main>
