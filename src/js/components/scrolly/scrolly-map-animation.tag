<sealevel-scrolly-map-animation>

  <svg ref="vis" />

  <sealevel-scrolly-map-legend />

  <span class="scrolly__map-animation__counter">
    { year }
  </span>

  <div class={
    scrolly__map-animation__end: true,
    scrolly__map-animation__end--active: !this.animationLoop
  }>
    <button class="scrolly__map-animation__restart" onclick={startAnimation}>
      { i18n.t('scrolly.restart') }
    </button>
  </div>

  <script type="text/babel">
    import './scrolly-map-legend.tag'
    import sparkVis from '../../mixins/sparkVis'

    const MIN_YEAR = 1985
    const MAX_YEAR = 2015
    const ANIMATION_DURATION = 1000
    const HEIGHT = 300
    const WIDTH = 6

    this.startAnimation = () => {
      this.stopAnimation()
      this.year = MIN_YEAR

      this.animationLoop = setInterval(() => {
        this.update({ year: ++this.year })
        if (this.year >= MAX_YEAR) this.stopAnimation()
      }, ANIMATION_DURATION)
    }

    this.stopAnimation = () => {
      clearInterval(this.animationLoop)
      this.update({ animationLoop: null })
    }

    this.on('mount', () => {
      // initialize(this.opts.map)
      this.mixin(sparkVis({
        container: this.refs.vis,
        map: this.opts.map,
        stations: this.opts.items,
        year: MIN_YEAR,
        animationDuration: ANIMATION_DURATION,
        width: WIDTH,
        height: HEIGHT
      }))

      this.startAnimation()
    })

    this.on('before-unmount', () => {
      this.stopAnimation()
    })

    this.on('updated', () => {
      this.sparkVis.redraw(this.year)
    })
  </script>
</sealevel-scrolly-map-animation>
