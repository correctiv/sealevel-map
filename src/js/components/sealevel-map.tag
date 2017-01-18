<sealevel-map>
    <div id="sealevel__map" class="sealevel__map"></div>

    <script type="text/babel">
        import 'leaflet_css'
        import 'leaflet_marker'
        import 'leaflet_marker_2x'
        import 'leaflet_marker_shadow'
        import L from 'leaflet'

        import * as d3 from 'd3'

        /* global variables */
        const parseTime = d3.utcParse('%Y-%m-%dT%H:%M:%S.%LZ');
        var counter = 1;
        var refreshID

        this.on('mount', () => {

            /* render map */
            const map = renderMap(opts.options)

            /* set domain and scale */
            const maxHeight = opts.options.overlayOptions.maxHeight;
            const domainValues = getDomainValues(opts.options.items)
            const yDomain = domainValues
            const scale = d3.scaleLinear().rangeRound([maxHeight, 0]).domain(yDomain);

            /* render stations on map */
            renderItems(map, scale, opts.options)

           /* redraw bars for torque effect  */
            var refreshID = setInterval(function() {
            redraw(opts.options.items, scale, refreshID)
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
        var countStation = 0;

        function renderItems (map, scale, { items, overlayOptions }) {

            let yScale = scale
            let barWidth = overlayOptions.barWidth;
            let mapOverlay = d3.select('#sealevel__map').select('svg g')

            /* parse data to get lat-long-coordinates and reformat timestamp */
            items.forEach(function (station) {
                station.LatLng = new L.LatLng(station.Latitude, station.Longitude)

                countStation++
                console.log(countStation)
                /*station.tideData.forEach(function (d) {
                    d.timestamp = parseTime(d.timestamp)
                    d.timestamp = d.timestamp.getFullYear()
                })*/
            })


            const feature = mapOverlay.selectAll('rect')
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
                    .on('click', function(station) {
                        opts.onmarkerclick(station.ID)
                    })
                    .on('mouseover', function (d) {
                        L.popup().setLatLng(d.LatLng)
                                .setContent(d.Location)
                                .openOn(map);
                    })
                    .on('mouseout', function (d) {
                        map.closePopup()
                    })

            map.on('zoom', function () {
                update();
            });

            update();

            function update() {
                feature.attr('transform',
                        function(d) {
                            let y = map.latLngToLayerPoint(d.LatLng).y - yScale(0);
                            let x = map.latLngToLayerPoint(d.LatLng).x;
                            return "translate("+ x +","+ y +")";
                        }
                )
            }
        }

        function redraw(data, scale, refreshID) {

            let yScale = scale
            let mapOverlay = d3.select('#sealevel__map').select('svg g')

            if(counter < 53) {
                counter++;

                mapOverlay.selectAll('rect')
                        .data(data)
                        .transition()
                        .duration(250)
                        .attr('y', function (d) {
                            if (d.tideData[counter] != undefined) {
                                return yScale(Math.max(0, d.tideData[counter].tide))
                            } else {
                                var lastObject = d.tideData.pop();
                                return yScale(Math.max(0, lastObject.tide))
                            }
                        })
                        .attr('height', function (d) {
                            if(d.tideData[counter] != undefined) {
                                return Math.abs(yScale(d.tideData[counter].tide) - yScale(0))
                            } else {
                                var lastObject = d.tideData.pop();
                                return Math.abs(yScale(lastObject.tide) - yScale(0))
                            }
                        })
                        .attr('class', function (d) {
                            if(d.tideData[counter] != undefined) {
                                return d.tideData[counter].tide < 0 ? "sealevel__map__bar--negative" : "sealevel__map__bar--positive"
                            } else {
                                var lastObject = d.tideData.pop()
                                return lastObject.tide < 0 ? "sealevel__map__bar--negative" : "sealevel__map__bar--positive"
                            }
                        })


            } else {
                clearInterval(refreshID)
            }
        }
    </script>
</sealevel-map>
