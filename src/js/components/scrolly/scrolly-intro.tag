<sealevel-scrolly-intro class={ intro--active: opts.active }>

  <h1>{ i18n.t('title') }</h1>

  <a href={ articlePath() }>{ i18n.t('read on') }</a>

  <script type="text/babel">
    import { article } from '../../routes/'

    this.articlePath = () => article(this.i18n.getLocale())
  </script>

</sealevel-scrolly-intro>
