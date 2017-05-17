<sealevel-scrolly-content>

  <script type="text/babel">
    const addContentSection = (stepName) => {
      const section = document.createElement('section')
      section.setAttribute('id', stepName)
      section.innerHTML = require(`../../../locale/de/${stepName}.md`)
      this.root.appendChild(section)
    }

    this.opts.steps.forEach(addContentSection)
  </script>

</sealevel-scrolly-content>
