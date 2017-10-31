<sealevel-scrolly-map-animation>

  <svg ref="vis" />

  <div class="container">
    <span class="scrolly__map-animation__counter">
      { year }
    </span>
  </div>

  <script type="text/babel">
    import sparkVis from '../../mixins/sparkVis'

    const MIN_YEAR = 1985
    const MAX_YEAR = 2015
    const ANIMATION_DURATION = 500
    const HEIGHT = 200
    const WIDTH = 6

    const startAnimation = () => {
      this.year = MIN_YEAR

      this.animationLoop = setInterval(() => {
        this.update({ year: ++this.year })
        if (this.year >= MAX_YEAR) stopAnimation()
      }, ANIMATION_DURATION)
    }

    const stopAnimation = () => {
      clearInterval(this.animationLoop)
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

      startAnimation()
    })

    this.on('unmount', () => {
      stopAnimation()
    })

    this.on('updated', () => {
      this.sparkVis.redraw(this.year)
    })
  </script>
</sealevel-scrolly-map-animation>
