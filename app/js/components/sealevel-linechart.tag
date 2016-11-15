<sealevel-linechart>

    <script type="text/babel">

        import * as d3 from 'd3'

        this.on('updated', () => {
            var data = this.opts.chartdata
            if (data) createChart(data, 200, 400)
        })

        var parseTime = d3.utcParse("%Y-%m-%dT%H:%M:%S.%LZ")
        var bisectDate = d3.bisector(function(d) { return d.date }).left
        var formatValue = d3.format(",.2f")

        function createChart(data, containerHeight, containerWidth) {
            data.forEach(function (d) {
                d.date = parseTime(d.timestamp)
            })

            d3.select("svg").remove();

            var svg = d3.select("sealevel-linechart").append("svg")
                    .attr("width", containerWidth)
                    .attr("height", containerHeight)

            var margin = { top: 40, left: 40, right: 40, bottom: 40 }

            var height = containerHeight - margin.top - margin.bottom
            var width = containerWidth - margin.left - margin.right

            var xDomain = d3.extent(data, function(d) { return d.date })
            var yDomain = d3.extent(data, function(d) { return d.tide; })

            var xScale =  d3.scaleTime().rangeRound([0, width]).domain(xDomain)
            var yScale = d3.scaleLinear().rangeRound([height, 0]).domain(yDomain)

            var line = d3.line()
                    .defined(function(d) { return d.tide!=null })
                    .x(function(d) { return xScale(d.date) })
                    .y(function(d) { return yScale(d.tide) })

            var g = svg.append('g').attr('transform', 'translate(' + margin.left + ', ' + margin.top + ')')

            g.append("g")
                    .attr("class", "axis axis--x")
                    .attr("transform", "translate(0," + height + ")")
                    .call(d3.axisBottom(xScale))

            g.append("g")
                    .attr("class", "axis axis--y")
                    .call(d3.axisLeft(yScale))
                    .append("text")
                    .attr("fill", "#000")
                    .attr("transform", "rotate(-90)")
                    .attr("y", 6)
                    .attr("dy", "0.71em")
                    .style("text-anchor", "end")
                    .text("Sea Level")

            g.append("path")
                    .datum(data)
                    .attr("class", "line")
                    .attr("d", line)

            // focus tracking

            var focus = g.append('g').style('display', 'none')

            focus.append('circle')
                    .attr('id', 'focusCircle')
                    .attr('r', 4.5)
                    .attr('class', 'circle focusCircle')

            focus.append("text")
                    .attr("x", 9)
                    .attr("dy", ".35em")

            focus.append('line')
                    .attr('id', 'focusLineX')
                    .attr('class', 'focusLine')

            focus.append('line')
                    .attr('id', 'focusLineY')
                    .attr('class', 'focusLine')

            g.append("rect")
                    .attr("class", "overlay")
                    .attr("width", width)
                    .attr("height", height)
                    .on("mouseover", function() { focus.style("display", null) })
                    .on("mouseout", function() { focus.style("display", "none") })
                    .on("mousemove", mousemove)

            function mousemove() {
                var mouse = d3.mouse(this)
                var mouseDate = xScale.invert(mouse[0])
                var i = bisectDate(data, mouseDate) // returns the index to the current data item

                var d0 = data[i - 1]
                var d1 = data[i]
                // work out which date value is closest to the mouse
                var d = mouseDate - d0[0] > d1[0] - mouseDate ? d1 : d0

                var x = xScale(d.date)
                var y = yScale(d.tide)

                focus.select("text")
                        .attr("transform", "translate(" + x + "," + y + ")")
                        .text(formatValue(d.tide))

                focus.select('#focusCircle')
                        .attr('cx', x)
                        .attr('cy', y)

                focus.select('#focusLineX')
                        .attr('x1', xScale(d.date)).attr('y1', yScale(yDomain[0]))
                        .attr('x2', xScale(d.date)).attr('y2', yScale(yDomain[1]))
                focus.select('#focusLineY')
                        .attr('x1', xScale(xDomain[0])).attr('y1', yScale(d.tide))
                        .attr('x2', xScale(xDomain[1])).attr('y2', yScale(d.tide))

            }

        }

    </script>


</sealevel-linechart>