<sealevel-linechart class="linechart">

  <svg ref="linechart"></svg>

  <span if={highlight} class="linechart__tooltip" style="left: {highlight.x}px">
    {highlight.value}
  </span>

  <script type="text/babel">
    import * as d3 from 'd3'
    import _ from 'lodash'

    const MARGIN = 40

    this.on('updated', () => {
      const series = this.opts.series.sort((a, b) => {
        return d3.max(a.data) < d3.max(b.data)
      })

      const data = series.map(s => d3.entries(s.data))
      const titles = series.map(s => s.title)

      createChart(data, titles)
    })

    const bisectDate = d3.bisector(d => d.key).left

    const getDomain = (seriesCollection, key) => {
      let min = d3.min(seriesCollection, (series) => {
        return d3.min(series, item => item[key])
      })

      let max = d3.max(seriesCollection, (series) => {
        return d3.max(series, item => item[key])
      })

      return [min, max]
    }

    const createChart = (data, titles) => {
      const container = this.refs.linechart
      const containerWidth = this.root.clientWidth
      const containerHeight = this.root.clientHeight
      const svg = d3.select(container)

      svg.selectAll('*').remove()
      svg.attr('width', containerWidth)
      svg.attr('height', containerHeight)

      const margin = {
        top: MARGIN,
        right: titles[0] ? MARGIN * 3 : MARGIN,
        bottom: MARGIN,
        left: MARGIN
      }

      const height = containerHeight - margin.top - margin.bottom
      const width = containerWidth - margin.left - margin.right

      const xDomain = getDomain(data, 'key')
      const yDomain = getDomain(data, 'value')

      const xScale = d3.scaleLinear().rangeRound([0, width]).domain(xDomain)
      const yScale = d3.scaleLinear().rangeRound([height, 0]).domain(yDomain)

      const line = d3.line()
        .defined(d => d.value !== null)
        .x(d => xScale(d.key))
        .y(d => yScale(d.value))
        .curve(d3.curveNatural)

      const g = svg.append('g')
        .attr('transform', `translate(${margin.left}, ${margin.top})`)

      g.append('g')
        .attr('class', 'linechart__axis linechart__axis-x')
        .attr('transform', 'translate(0,' + height + ')')
        .call(d3.axisBottom(xScale).ticks(5).tickFormat(d3.format('d')))

      g.append('g')
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
        g.append('path')
          .datum(item)
          .attr('class', `linechart__line linechart__line--${index}`)
          .attr('d', line)

        g.append('text')
          .text(titles[index])
          .attr('x', containerWidth - MARGIN * 4)
          .attr('y', yScale(_.last(item).value))
          .attr('dx', '0.3em')
          .attr('dy', '0.3em')
          .attr('class', `linechart__label linechart__label--${index}`)
      })

      // focus tracking
      const focus = g.append('g')

      const onMousemove = (dataItem, index, [overlay]) => {
        const mouse = d3.mouse(overlay)
        const mouseDate = xScale.invert(mouse[0])
        const i = bisectDate(data[0], mouseDate) // returns the index to the current data item
        const d = data[0][i]
        const x = xScale(d.key)
        const y = yScale(d.value)

        this.update({
          highlight: { x, y, value: d.value }
        })
      }

      if (this.highlight) {
        focus.append('circle')
          .attr('id', 'linechart__focuscircle')
          .attr('r', 4.5)
          .attr('class', 'linechart__circle')
          .attr('cx', this.highlight.x)
          .attr('cy', this.highlight.y)

        focus.append('line')
          .attr('id', 'linechart__focusLineX')
          .attr('class', 'linechart__focusline')
          .attr('x1', this.highlight.x).attr('y1', 0)
          .attr('x2', this.highlight.x).attr('y2', height)
      }

      g.append('rect')
        .attr('class', 'linechart__overlay')
        .attr('width', width)
        .attr('height', height)
        .on('mousemove', onMousemove)
    }
  </script>


</sealevel-linechart>
