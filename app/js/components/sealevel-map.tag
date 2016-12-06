<sealevel-map>
    <div id="sealevel__map" class="sealevel__map"></div>
    <sealevel-map-slider value={ this.year } oninput={ this.onSliderInput } class="overlay"></sealevel-map-slider>
    <p class="overlay">{ year }</p>

    <p class="overlay">{ value }</p>

    <script type="text/babel">

        import * as d3 from 'd3'
        import L from 'leaflet'

        /* global variables */
        const parseTime = d3.utcParse('%Y-%m-%dT%H:%M:%S.%LZ')
        const that = this
        that.year = 1807
        var refreshID

        this.on('mount', () => {
            /* render map */
            const map = renderMap(opts.options)

            /* set domain and scale */
            const maxHeight = opts.options.overlayOptions.maxHeight;
            const domainValues = getDomainValues(opts.options.items)
            const yDomain = domainValues

            const yMin = Math.abs(yDomain[0])
            const yMax = yDomain[1]

            const scale = d3.scaleSqrt().rangeRound([maxHeight, 0]).domain(yDomain)

            const scaleCircle = d3.scaleLinear().range([3, 9]).domain([0, yMin])
            const scaleOpacity = d3.scaleSqrt().range([0.3, 0.9]).domain(yDomain)

            const colorScalePos = d3.scaleSqrt()
                    .range([d3.rgb('lightgreen'), d3.rgb('darkgreen')]).domain([0, yMax])

            const colorScaleNeg = d3.scaleSqrt()
                    .range([d3.rgb('lightred'), d3.rgb('darkred')]).domain([0, yMin])

            /* render stations on map */
            renderItems(map, scale, opts.options, colorScalePos)

            /* redraw bars for torque effect  */
          var refreshID = setInterval(function() {
                redraw(opts.options.items, scale, refreshID, colorScalePos, colorScaleNeg, scaleCircle, scaleOpacity)
            }, 500)

        })

        function renderMap ( { center, zoom, tiles, attribution } ) {
            const map = L.map('sealevel__map', { center, zoom })
            const tileLayer = L.tileLayer(tiles, { attribution } )

            map.addLayer(tileLayer)
            map.zoomControl.setPosition('topleft')
            map.scrollWheelZoom.disable()

            /* Initialize the SVG layer */
            L.svg().addTo(map)

            return map
        }

        function getDomainValues (items) {
            let yDomain

            let yMin = d3.min(items, function (station) {
                return d3.min(station.tideData, function (d) {
                    return d.tide;
                })
            })

            let yMax = d3.max(items, function (station) {
                return d3.max(station.tideData, function (d) {
                    return d.tide;
                })
            })
            return yDomain = [yMin, yMax]
        }

        /*function findYear(tideObject) {
         for (var i = year - 5; i <= year; i++) {
         if (tideObject.year === i) {
         return tideObject
         } else {
         continue
         }
         }
         }*/

        function findYear(tideObject) {
            if (tideObject.year === that.year) {
                return tideObject
            }
        }

        function findTide(station) {
            if (station.tideData.find(findYear)) {
                let tideObject = station.tideData.find(tide => findYear(tide))
                return tideObject.tide
            }
        }

        function renderItems (map, scale, { items, overlayOptions }, colorScale) {

            let yScale = scale
            let barWidth = overlayOptions.barWidth;
            let mapOverlay = d3.select('#sealevel__map').select('svg g')

            /* parse data to get lat-long-coordinates and reformat timestamp */
            items.forEach(function (station) {
                station.LatLng = new L.LatLng(station.Latitude, station.Longitude)
                station.tideData.forEach(function (d) {
                    d.year = parseTime(d.timestamp)
                    d.year = d.year.getFullYear()
                })
            })

            const circleMarker = mapOverlay.selectAll('circle')
                    .data(items)
                    .enter().append('circle')
                    .attr("r",  station => {
                        if (findYear(station)) {
                            return 5
                        }
                    })
                    //.attr("class", "sealevel__map__circle" )
                    .on('click', station => {
                        opts.onmarkerclick(station.ID)
                    })
                    .on('mouseover', station => {
                        L.popup().setLatLng(station.LatLng)
                                .setContent(station.Location)
                                .openOn(map);
                    })
                    .on('mouseout', station => {
                        map.closePopup()
                    })


            const bar = mapOverlay.selectAll('rect')
                    .data(items)
                    .enter().append('rect')
                    .attr('class', 'sealevel__map__bar')
                    .attr('y', function (station) {
                        return yScale(Math.max(0, station.tideData[0].tide))
                    })
                    .attr('height', function (station) {
                        return Math.abs(yScale(station.tideData[0].tide) - yScale(0))
                    })
                    .attr('width', barWidth)

            map.on('zoom', function () {
                update();
            });

            update();

            function update() {

                bar.attr('transform',
                        function(d) {
                            let y = map.latLngToLayerPoint(d.LatLng).y - yScale(0);
                            let x = map.latLngToLayerPoint(d.LatLng).x - (barWidth / 2);
                            return "translate("+ x +","+ y +")";
                        }
                )
                circleMarker.attr('transform',
                        function(d) {
                            let y = map.latLngToLayerPoint(d.LatLng).y;
                            let x = map.latLngToLayerPoint(d.LatLng).x;
                            return "translate("+ x +","+ y +")";
                        }
                )
            }
        }

        function redraw(data, scale, refreshID, colorScalePos, colorScaleNeg, scaleCircle, scaleOpacity) {

            let yScale = scale
            let mapOverlay = d3.select('#sealevel__map').select('svg g')

            if(that.year < 2010) {

                that.update({ year: ++that.year })

                mapOverlay.selectAll('circle')
                        .data(data)
                        .transition()
                        .duration(250)
                        /*.attr("r",  function (station) {
                         if (station.tideData[0].year <= year) {
                         return 5
                         }
                         })*/
                        .attr("r", station => {
                            if (findTide(station)) {
                                let tide = Math.abs(findTide(station))
                                return scaleCircle(tide)
                            }
                        })
                        .attr("fill", function (station) {
                            if (findTide(station)) {
                                let tide = findTide(station)
                                if (tide < 0) {
                                    return colorScaleNeg(findTide(station))
                                } else {
                                    return colorScalePos(findTide(station))
                                }
                            }

                        })
                        .attr("fill-opacity", function (station) {
                            if (findTide(station)) {
                                return scaleOpacity(findTide(station))
                            }
                        })


                /* mapOverlay.selectAll('rect')
                 .data(data)
                 .transition()
                 .duration(250)
                 .attr('y', function (station) {
                 if (findTide(station)) {
                 return yScale(Math.max(0, findTide(station)))
                 } else {
                 return yScale(Math.max(0, station.tideData[0].tide))
                 }
                 })
                 .attr('height', function (station) {
                 if (findTide(station)) {
                 return Math.abs(yScale(findTide(station)) - yScale(0))
                 } else {
                 return Math.abs(yScale(station.tideData[0].tide) - yScale(0))
                 }
                 })
                 .attr('class', function (station) {
                 if (findTide(station)) {
                 return findTide(station) < 0 ? "sealevel__map__bar--negative" : "sealevel__map__bar--positive"
                 }
                 })
                 */


            } else {
                clearInterval(refreshID)
            }
        }

        this.onSliderInput = (year) => {
            this.update({year})
        }
    </script>
</sealevel-map>