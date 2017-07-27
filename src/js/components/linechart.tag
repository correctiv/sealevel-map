<sealevel-linechart class="linechart">

  <svg ref="linechart"></svg>

  <script type="text/babel">
    import * as d3 from 'd3'

    this.on('updated', () => {
      this.opts.chartdata && createChart(this.opts.chartdata, 200, 400)
    })

    const bisectDate = d3.bisector(d => d.year).left

    const createChart = (data) => {
      const container = this.refs.linechart
      const containerWidth = container.clientWidth
      const containerHeight = container.clientHeight
      const svg = d3.select(container)

      svg.selectAll('*').remove()
      svg.attr('width', containerWidth)
      svg.attr('height', containerHeight)

      const margin = { top: 40, left: 40, right: 40, bottom: 40 }

      const height = containerHeight - margin.top - margin.bottom
      const width = containerWidth - margin.left - margin.right

      const xDomain = d3.extent(data, d => d.year)
      const yDomain = d3.extent(data, d => d.tide)

      const xScale = d3.scaleLinear().rangeRound([0, width]).domain(xDomain)
      const yScale = d3.scaleLinear().rangeRound([height, 0]).domain(yDomain)

      const line = d3.line()
        .defined(d => d.tide !== null)
        .x(d => xScale(d.year))
        .y(d => yScale(d.tide))
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
        .text('Sea Level')

      g.append('path')
        .datum(data)
        .attr('class', 'linechart__line')
        .attr('d', line)

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
        const i = bisectDate(data, mouseDate) // returns the index to the current data item

        const d0 = data[i - 1]
        const d1 = data[i]
        // work out which date value is closest to the mouse
        const d = mouseDate - d0[0] > d1[0] - mouseDate ? d1 : d0

        const x = xScale(d.year)
        const y = yScale(d.tide)

        focus.select('text')
          .attr('transform', 'translate(' + x + ')')
          .text(d.tide)

        focus.select('#linechart__focuscircle')
          .attr('cx', x)
          .attr('cy', y)

        focus.select('#linechart__focusLineX')
          .attr('x1', xScale(d.year)).attr('y1', yScale(yDomain[0]))
          .attr('x2', xScale(d.year)).attr('y2', yScale(yDomain[1]))
      }
    }
  </script>


</sealevel-linechart>
