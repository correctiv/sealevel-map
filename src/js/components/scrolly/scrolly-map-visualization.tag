<sealevel-scrolly-map-visualization class="scrolly__map-visualization {
  scrolly__map-visualization--hidden: isMoving
}">

  <svg>
    <g ref="vis" />
    <g ref="annotations" />
  </svg>

  <sealevel-scrolly-map-visualization-tooltip
    if={tooltip}
    value={tooltip.value}
    location={tooltip.location}
    position={tooltip.position}
  />

  <script type="text/babel">
    import * as d3 from 'd3'
    import * as d3Annotation from 'd3-svg-annotation'
    import sparkVis from '../../mixins/sparkVis'
    import './scrolly-map-visualization-tooltip.tag'

    const MIN_YEAR = 1985
    const MAX_YEAR = 2015
    const HEIGHT = 500
    const WIDTH = 12

    const customAnnotation = d3Annotation.annotationCustomType(
      d3Annotation.annotationCallout, {
        'className': 'custom',
        'connector': { 'end': 'dot' },
        'note': { 'lineType': 'horizontal' }
      })

    const labels = [{
      data: { lonLat: ['120.968', '14.58'] },
      note: {
        title: 'Der Pegel Manila',
        label: 'ist in 30 Jahren um fast 40cm gestiegen.'
      },
      dy: 30,
      dx: -30,
      type: customAnnotation,
      color: 'black'
    },
    {
      data: {
        lonLat: ['120.91', '14.71']
      },
      note: {
        title: 'Besonders gefährdet',
        label: 'sind Gebiete unterhalb von 10 Meter über dem Meer.'
      },
      dy: 30,
      dx: -30,
      type: customAnnotation,
      color: 'black'
    }]

    const isMoving = () => {
      this.update({
        isMoving: opts.map.isMoving()
      })
    }

    const isDefined = (value) => typeof value !== 'undefined'

    const getTide = (timeseries) => {
      const minValue = timeseries[MIN_YEAR]
      const maxValue = timeseries[MAX_YEAR]

      if (isDefined(minValue) && isDefined(maxValue)) {
        return maxValue - minValue
      }

      return 0
    }

    const showTip = ({ location, timeseries }, position) => {
      this.update({
        tooltip: {
          location,
          value: getTide(timeseries),
          position
        }
      })
    }

    const hideTip = () => {
      this.update({ tooltip: null })
    }

    this.isMoving = true
    this.tooltip = null

    this.on('mount', () => {
      // initialize visualization
      this.mixin(sparkVis({
        container: this.refs.vis,
        map: this.opts.map,
        stations: this.opts.items,
        minYear: MIN_YEAR,
        maxYear: MAX_YEAR,
        width: WIDTH,
        height: HEIGHT,
        tooltip: { show: showTip, hide: hideTip }
      }))

      this.sparkVis.redraw()

      // synchronize state with map movement (for hiding/showing)
      this.opts.map.on('movestart', isMoving)
      this.opts.map.on('moveend', isMoving)

      // redraw visualization whenever the view changes
      this.opts.map.on('viewreset', this.sparkVis.redraw)
      this.opts.map.on('move', this.sparkVis.redraw)
    })

    this.on('unmount', () => {
      // remove map event handlers before unmounting
      this.opts.map.off('movestart', isMoving)
      this.opts.map.off('moveend', isMoving)
      this.opts.map.off('movestart', isMoving)
      this.opts.map.off('moveend', isMoving)
    })

    this.on('redraw', (projection) => {
      const makeAnnotations = d3Annotation.annotation()
        .annotations(labels)
        .textWrap(180)
        .accessors({
          x: ({ lonLat }) => projection(lonLat)[0],
          y: ({ lonLat }) => projection(lonLat)[1]
        })

      d3.select(this.refs.annotations)
        .call(makeAnnotations)
    })

  </script>
</sealevel-scrolly-map-visualization>
