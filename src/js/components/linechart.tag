<sealevel-linechart class="linechart">

  <svg ref="linechart"></svg>

  <script type="text/babel">
    import * as d3 from 'd3'

    this.on('updated', () => {
      const series = this.opts.series.map(s => d3.entries(s.data))
      createChart(series)
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

    const createChart = (data) => {
      const container = this.refs.linechart
      const containerWidth = this.root.clientWidth
      const containerHeight = this.root.clientHeight
      const svg = d3.select(container)

      svg.selectAll('*').remove()
      svg.attr('width', containerWidth)
      svg.attr('height', containerHeight)

      const margin = { top: 40, left: 40, right: 40, bottom: 40 }

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

      const g = svg.append('g').attr('transform', 'translate(' + margin.left + ', ' + margin.top + ')')

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
        .attr('dy', '0.71em')
        .style('text-anchor', 'end')
        .text(this.i18n.t('explorer.linechart_axis'))

      data.forEach((item, index) => {
        g.append('path')
          .datum(item)
          .attr('class', `linechart__line linechart__line--${index}`)
          .attr('d', line)
      })

      // focus tracking

      const focus = g.append('g').style('display', 'none')

      focus.append('circle')
        .attr('id', 'linechart__focuscircle')
        .attr('r', 4.5)
        .attr('class', 'linechart__circle')

      focus.append('text')
        .attr('x', 9)
        .attr('dy', '.35em')

      focus.append('line')
        .attr('id', 'linechart__focusLineX')
        .attr('class', 'linechart__focusline')

      focus.append('line')
        .attr('id', 'linechart__focusLineY')
        .attr('class', 'linechart__focusline')

      g.append('rect')
        .attr('class', 'linechart__overlay')
        .attr('width', width)
        .attr('height', height)
        .on('mouseover', () => focus.style('display', null))
        .on('mouseout', () => focus.style('display', 'none'))
        .on('mousemove', mousemove)

      function mousemove () {
        const mouse = d3.mouse(this)
        const mouseDate = xScale.invert(mouse[0])
        const i = bisectDate(data[0], mouseDate) // returns the index to the current data item
        const d = data[0][i]
        const x = xScale(d.key)
        const y = yScale(d.value)

        focus.select('text')
          .attr('transform', 'translate(' + x + ')')
          .text(d.value)

        focus.select('#linechart__focuscircle')
          .attr('cx', x)
          .attr('cy', y)

        focus.select('#linechart__focusLineX')
          .attr('x1', xScale(d.key)).attr('y1', yScale(yDomain[0]))
          .attr('x2', xScale(d.key)).attr('y2', yScale(yDomain[1]))
      }
    }
  </script>


</sealevel-linechart>
