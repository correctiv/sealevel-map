<sealevel-scrolly-map-visualization-tooltip
  class="scrolly__map-visualization__tooltip"
  style={getStyle(opts.position)}
>
  <h4 class="scrolly__map-visualization__tooltip__location">
    {opts.location}
  </h4>
  <p class="scrolly__map-visualization__tooltip__value">
    <strong>{opts.value}mm</strong> {i18n.t('scrolly.period')}
  </p>

  <script type="text/babel">
    this.getStyle = ([x, y]) => `left: ${x || 0}px; top: ${y || 0}px`
  </script>
</sealevel-scrolly-map-visualization-tooltip>
