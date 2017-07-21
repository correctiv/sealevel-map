<sealevel-scrolly-header class="scrolly__header" id="main">

  <div class="container">

    <h1 class="scrolly__title">
      { i18n.t('scrolly.title') }
    </h1>

    <div ref="content"></div>

  </div>

  <script type="text/babel">
    this.on('update', () => {
      const lang = this.i18n.getLocale()
      const content = require(`../../../locale/${lang}/header.md`)
      this.refs.content.innerHTML = content
    })
  </script>

</sealevel-scrolly-header>
