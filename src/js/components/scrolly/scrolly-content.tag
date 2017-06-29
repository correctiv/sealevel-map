<sealevel-scrolly-content>

  <script type="text/babel">
    const addContentSection = (stepName) => {
      const section = document.createElement('section')
      const sectionWrapper = document.createElement('div')
      sectionWrapper.className = 'scrolly__content'
      section.setAttribute('id', stepName)
      section.setAttribute('class', `scrolly__section--${stepName}`)
      section.appendChild(sectionWrapper)
      sectionWrapper.innerHTML = require(`../../../locale/${this.locale}/${stepName}.md`)
      this.root.appendChild(section)
    }

    const updateContent = () => {
      this.opts.steps.forEach(addContentSection)
    }

    // Only update when the language has changed
    this.shouldUpdate = () => {
      if (this.locale !== this.i18n.getLocale()) {
        return true
      }
    }

    this.on('update', () => {
      this.locale = this.i18n.getLocale()
      updateContent()
    })
  </script>

</sealevel-scrolly-content>
