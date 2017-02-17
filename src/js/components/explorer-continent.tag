<sealevel-explorer-continent>

  <ul>
    <li each={ country in opts.countries } >
      <a href={ route(country) }>{ country }</a>
    </li>
  </ul>

  <script type="text/babel">
    this.route = (id) => `#${opts.pathToCountry(id)}`
  </script>

</sealevel-explorer-continent>
