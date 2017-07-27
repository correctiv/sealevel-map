<sealevel-scrolly-main class="scrolly__main">

  <div class="scrolly__main__wrapper">
    <div class="container">
      <div class="scrolly__main__content">

        <h1 class="scrolly__title">
          { i18n.t('scrolly.title') }
        </h1>

        <div class="scrolly__main__sidebar">

          <div class="scrolly__main__authors">
            { i18n.t('scrolly.authors') }
            <em>Annika Jöres,</em>
            <em>Simon Jockers,</em>
            <em>Felix Michel</em>
          </div>

          <div class="scrolly__main__partners">
            <h4>{ i18n.t('scrolly.partners') }</h4>
            [Partner Logos]
          </div>

        </div>

        <div class="scrolly__main__body">
          { i18n.t('scrolly.introduction') }
        </div>

        <figure class="scrolly__figure--marginal">
          <img src="/assets/content/pegel_genua.jpg" alt="" />
          <figcaption class="scrolly__figure__caption">
            <p>{ i18n.t('scrolly.tide_figcaption') }</p>
            <p>
              { i18n.t('scrolly.credits') }
              <a href="https://commons.wikimedia.org/w/index.php?curid=37402118">Motnbkl</a>,
              <a href="http://creativecommons.org/licenses/by-sa/4.0">CC-BY-SA 4.0</a>
            </p>
          </figcaption>
        </figure>

        <div class="scrolly__main__body" ref="body"></div>

      </div>
    </div>
  </div>

  <script type="text/babel">
    this.on('update', () => {
      const lang = this.i18n.getLocale()
      const body = require(`../../../locale/${lang}/main.md`)
      this.refs.body.innerHTML = body
    })
  </script>

</sealevel-scrolly-main>
