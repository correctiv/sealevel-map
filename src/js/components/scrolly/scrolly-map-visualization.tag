<sealevel-scrolly-map-visualization class={
  scrolly__map-visualization: true,
  scrolly__map-visualization--hidden: isMoving
}>

  <svg>
    <g ref="vis" />
    <g ref="annotations" />
  </svg>

  <sealevel-scrolly-map-legend />

  <sealevel-scrolly-map-visualization-tooltip
    if={tooltip}
    tide={tooltip.tide}
    location={tooltip.location}
    point={tooltip.point}
  />

  <script type="text/babel">
    import * as d3 from 'd3'
    import * as d3Annotation from 'd3-svg-annotation'
    import sparkVis from '../../mixins/sparkVis'
    import './scrolly-map-visualization-tooltip.tag'
    import './scrolly-map-legend.tag'

    const YEAR = 2015
    const HEIGHT = 500
    const WIDTH = 12

    const customAnnotation = d3Annotation.annotationCustomType(
      d3Annotation.annotationCallout, {
        className: 'custom',
        connector: { 'end': 'dot' },
        note: { 'lineType': 'horizontal' }
      })

    const labels = [{
      data: { lonLat: ['120.968', '14.58'] },
      note: {
        title: this.i18n.t('scrolly.annotations.manila.city.title'),
        label: this.i18n.t('scrolly.annotations.manila.city.label')
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
        title: this.i18n.t('scrolly.annotations.manila.region.title'),
        label: this.i18n.t('scrolly.annotations.manila.region.label')
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

    const showTip = (tooltip) => {
      this.update({ tooltip })
    }

    const hideTip = () => {
      this.update({ tooltip: null })
    }

    this.isMoving = false
    this.tooltip = null

    this.on('mount', () => {
      // initialize visualization
      this.mixin(sparkVis({
        container: this.refs.vis,
        map: this.opts.map,
        stations: this.opts.items,
        year: YEAR,
        width: WIDTH,
        height: HEIGHT,
        tooltip: { show: showTip, hide: hideTip }
      }))

      this.sparkVis.redraw()

      // synchronize state with map movement (for hiding/showing)
      this.opts.map.on('movestart', isMoving)
      this.opts.map.on('moveend', isMoving)
    })

    this.on('unmount', () => {
      // remove map event handlers before unmounting
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
