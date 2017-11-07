<sealevel-scrolly-intro class={ intro: true, intro--active: opts.active }>

  <div class="intro__wrapper">

    <div class="container">
      <h1 class="intro__title">{ i18n.t('intro.title') }</h1>

      <a href="https://correctiv.org/" class="intro__logo-correctiv">
        CORRECTIV
      </a>
    </div>

    <video autoplay muted loop poster="../{ video.jpg }">
      <source src="../{ video.mp4 }" type="video/mp4">
      <source src="../{ video.webm }" type="video/webm">
    </video>

    <div class="intro__lead">
      <p>{ i18n.t('intro.lead') }</p>
    </div>

    <a class="intro__more" href={ articlePath() }>
      { i18n.t('intro.more') }
    </a>

  </div>

  <script type="text/babel">
    import { article } from '../../routes/'

    this.video = {
      jpg: require('file!../../../assets/images/intro.jpg'),
      mp4: require('file?&mimetype=video/mp4!../../../assets/videos/intro.mp4'),
      webm: require('file?&mimetype=video/webm!../../../assets/videos/intro.webm')
    }

    this.articlePath = () => article(this.i18n.getLocale())

  </script>

</sealevel-scrolly-intro>
