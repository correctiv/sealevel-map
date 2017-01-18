<sealevel-linechart>

  <svg id='linechart-container'></svg>

  <script type='text/babel'>
    import * as d3 from 'd3'

    this.on('updated', () => {
      const data = this.opts.chartdata
      if (data) createChart(data, 200, 400)
    })

    const parseTime = d3.utcParse('%Y-%m-%dT%H:%M:%S.%LZ')
    const bisectDate = d3.bisector(d => d.date).left
    const formatValue = d3.format(',.2f')

    function createChart (data, containerHeight, containerWidth) {
      data.forEach(function (d) {
        d.date = parseTime(d.timestamp)
      })

      const svg = d3.select('#linechart-container')
      svg.selectAll('*').remove()
      svg.attr('width', containerWidth)
      svg.attr('height', containerHeight)

      const margin = { top: 40, left: 40, right: 40, bottom: 40 }

      const height = containerHeight - margin.top - margin.bottom
      const width = containerWidth - margin.left - margin.right

      const xDomain = d3.extent(data, d => d.date)
      const yDomain = d3.extent(data, d => d.tide)

      const xScale = d3.scaleTime().rangeRound([0, width]).domain(xDomain)
      const yScale = d3.scaleLinear().rangeRound([height, 0]).domain(yDomain)

      const line = d3.line()
        .defined(d => d.tide !== null)
        .x(d => xScale(d.date))
        .y(d => yScale(d.tide))
        .curve(d3.curveNatural)

      const g = svg.append('g').attr('transform', 'translate(' + margin.left + ', ' + margin.top + ')')

      g.append('g')
        .attr('class', 'sealevel__linechart__axis sealevel__linechart__axis-x')
        .attr('transform', 'translate(0,' + height + ')')
        .call(d3.axisBottom(xScale).ticks(5))

      g.append('g')
        .attr('class', 'sealevel__linechart__axis sealevel__linechart__axis-y')
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
        .attr('class', 'sealevel__linechart__line')
        .attr('d', line)

      // focus tracking

      const focus = g.append('g').style('display', 'none')

      focus.append('circle')
        .attr('id', 'sealevel__linechart__focuscircle')
        .attr('r', 4.5)
        .attr('class', 'sealevel__linechart__circle')

      focus.append('text')
        .attr('x', 9)
        .attr('dy', '.35em')

      focus.append('line')
        .attr('id', 'sealevel__linechart__focusLineX')
        .attr('class', 'sealevel__linechart__focusline')

      focus.append('line')
        .attr('id', 'sealevel__linechart__focusLineY')
        .attr('class', 'sealevel__linechart__focusline')

      g.append('rect')
        .attr('class', 'sealevel__linechart__overlay')
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

        const x = xScale(d.date)
        const y = yScale(d.tide)

        focus.select('text')
          .attr('transform', 'translate(' + x + ')')
          .text(formatValue(d.tide))

        focus.select('#sealevel__linechart__focuscircle')
          .attr('cx', x)
          .attr('cy', y)

        focus.select('#sealevel__linechart__focusLineX')
          .attr('x1', xScale(d.date)).attr('y1', yScale(yDomain[0]))
          .attr('x2', xScale(d.date)).attr('y2', yScale(yDomain[1]))

        // focus.select('#sealevel__linechart__focusLineY')
        //   .attr('x1', xScale(xDomain[0])).attr('y1', yScale(d.tide))
        //   .attr('x2', xScale(xDomain[1])).attr('y2', yScale(d.tide))
      }
    }
  </script>


</sealevel-linechart>
