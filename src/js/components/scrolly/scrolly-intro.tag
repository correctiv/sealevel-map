<sealevel-scrolly-intro class={ intro: true, intro--active: opts.active }>

  <h1 class="intro__title">{ i18n.t('title') }</h1>

  <p class="intro__logo-correctiv">Ein Projekt von CORRECTIV</p>

  <video autoplay muted loop poster="intro.jpg">
    <source src="../{ videos.mp4 }" type="video/mp4">
    <source src="../{ videos.webm }" type="video/webm">
  </video>

  <p class="intro__lead">
    <a class="intro__more" href={ articlePath() }>{ i18n.t('read on') }</a>
  </p>

  <script type="text/babel">
    import { article } from '../../routes/'

    this.videos = {
      mp4: require('file?&mimetype=video/mp4!../../../assets/videos/intro.mp4'),
      webm: require('file?&mimetype=video/webm!../../../assets/videos/intro.webm')
    }

    this.articlePath = () => article(this.i18n.getLocale())
  </script>

</sealevel-scrolly-intro>
