<sealevel-language-switch>

  <select onchange={selectLanguage} value={currentLanguage}>
    <option each={locales} value={locale}>{title}</option>
  </select>

  <script type="text/babel">
    import route from 'riot-route'

    this.locales = [
      {title: 'Deutsch', locale: 'de'},
      {title: 'English', locale: 'en'}
    ]

    this.selectLanguage = ({ target }) => {
      this.opts.route(target.value)
    }

    this.on('update', () => {
      this.currentLanguage = this.i18n.getLocale()
    })
  </script>

</sealevel-language-switch>
