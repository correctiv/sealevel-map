<sealevel-linechart class="linechart">

  <svg riot-width={root.clientWidth} riot-height={root.clientHeight}>

    <g class="linechart__graphs" ref="linechart" />

    <g class="linechart__overlay">

      <rect onmousemove={onMousemove}
        if={width && height}
        riot-width={width}
        riot-height={height}
      />

      <line class='linechart__focusline'
        if={highlight}
        riot-x1={highlight.x}
        riot-x2={highlight.x}
        riot-y1=0
        riot-y2={height}
      />

      <circle class='linechart__circle'
        if={highlight}
        riot-cx={highlight.x}
        riot-cy={highlight.y}
      />
    </g>

  </svg>

  <span if={highlight} class="linechart__tooltip" style={getTooltipStyle()}>
    {highlight.key} <strong>{highlight.value}&nbsp;mm</strong>
  </span>

  <script type="text/babel">
    import * as d3 from 'd3'
    import _ from 'lodash'

    const MARGIN = 40

    let data, titles, xScale, yScale

    const bisectDate = d3.bisector(d => d.key).left

    const getDomain = (seriesCollection, key) => {
      const min = d3.min(seriesCollection, (series) => {
        return d3.min(series, item => item[key])
      })

      const max = d3.max(seriesCollection, (series) => {
        return d3.max(series, item => item[key])
      })

      return [min, max]
    }

    const createChart = () => {
      const container = d3.select(this.refs.linechart)

      const line = d3.line()
        .defined(d => d.value !== null)
        .x(d => xScale(d.key))
        .y(d => yScale(d.value))
        .curve(d3.curveMonotoneX)

      container.selectAll('g, path, text').remove()

      container.append('g')
        .attr('class', 'linechart__axis linechart__axis-x')
        .attr('transform', 'translate(0,' + this.height + ')')
        .call(d3.axisBottom(xScale).ticks(5).tickFormat(d3.format('d')))

      container.append('g')
        .attr('class', 'linechart__axis linechart__axis-y')
        .call(d3.axisLeft(yScale).ticks(5))
        .append('text')
        .attr('fill', '#000')
        .attr('y', -15)
        .attr('x', 5)
        .attr('dy', '0.5em')
        .style('text-anchor', 'end')
        .text(this.i18n.t('explorer.linechart_axis'))

      data.forEach((item, index) => {
        container.append('path')
          .datum(item)
          .attr('class', `linechart__line linechart__line--${index}`)
          .attr('d', line)

        container.append('text')
          .text(titles[index])
          .attr('x', this.root.clientWidth - MARGIN * 4)
          .attr('y', yScale(_.last(item).value))
          .attr('dx', '0.3em')
          .attr('dy', '0.3em')
          .attr('class', `linechart__label linechart__label--${index}`)
      })
    }

    this.on('update', () => {
      const series = this.opts.series.sort((a, b) => {
        return d3.max(a.data) < d3.max(b.data)
      })

      data = series.map(s => d3.entries(s.data))
      titles = series.map(s => s.title)

      const vMargin = MARGIN * 2
      const hMargin = titles[0] ? MARGIN * 4 : vMargin

      this.height = this.root.clientHeight - vMargin
      this.width = this.root.clientWidth - hMargin

      const xDomain = getDomain(data, 'key')
      const [yMin, yMax] = getDomain(data, 'value')
      const yDomain = [Math.min(-200, yMin), Math.max(300, yMax)]

      xScale = d3.scaleLinear().rangeRound([0, this.width]).domain(xDomain)
      yScale = d3.scaleLinear().rangeRound([this.height, 0]).domain(yDomain)

      createChart()
    })

    this.getTooltipStyle = () => `left: ${this.highlight.x + MARGIN}px`

    this.onMousemove = ({offsetX}) => {
      const mouseDate = xScale.invert(offsetX - MARGIN)
      const i = bisectDate(data[0], mouseDate) // returns the index to the current data item
      const { key, value } = data[0][i]

      this.update({
        highlight: {
          x: xScale(key),
          y: yScale(value),
          value,
          key
        }
      })
    }

    // this.onMouseout = () => this.update({highlight: null})

  </script>


</sealevel-linechart>
