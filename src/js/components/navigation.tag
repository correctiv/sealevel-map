<sealevel-navigation>

  <ul class="bullet-list">
    <li class="bullet-list__item" each="{ slug, key in this.opts.steps }">
      <a href="#{slug}" class="link {link--active: this.isActive(slug)}">
        { slug }
      </a>
    </li>
  </ul>

  <script type="text/babel">
    this.isActive = id => this.opts.active === id
  </script>

</sealevel-navigation>
