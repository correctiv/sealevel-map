<sealevel-scrolly-intro class={ intro--active: opts.active }>

  <h1>Rising Seas</h1>

  <a href={ articlePath() }>Read on</a>

  <script type="text/babel">
    import { article } from '../../routes/'

    this.articlePath = () => article(this.opts.locale)
  </script>

</sealevel-scrolly-intro>
