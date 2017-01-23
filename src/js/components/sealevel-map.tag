<sealevel-map>

  <sealevel-navigation class="sealevel__navigation"></sealevel-navigation>

  <sealevel-map-slider if="{ this.next }" value="{ this.year }" oninput="{ this.onSliderInput }" class="slider"></sealevel-map-slider>

  <div class="sealevel__map__infobox">
    For decades human beings measured sea level in areas around important harbors.
    Tide gauge readings tell us that over the past century,
    the Global Mean Sea Level has risen in most regions.
    This map is made using data measured from 1807 to 2015.
    The height of the triangles reflects the sea level relative to the surface.
    The colors represent the trend in the sea level – red for the rise and blue for the decline.
    <br /><br />
    <a href="#" onclick={go}>Tell me more!</a>
  </div>

  <div id="sealevel__map" class="sealevel__map"></div>

  <script type="text/babel">
    import * as d3 from 'd3'
    import L from 'leaflet'
    import LeafletD3Layer from '../lib/leaflet-d3-layer.js'
    import 'leaflet_css'
    import 'leaflet_marker'
    import 'leaflet_marker_2x'
    import 'leaflet_marker_shadow'

    this.next = true

    const parseTime = d3.utcParse('%Y-%m-%dT%H:%M:%S.%LZ')
    const that = this
    that.year = 1807

    this.go = function (e) {
      opts.onnextclick(1)
      this.update({
        next: false
      })
    }

    this.on('mount', () => {
      /* render map */
      const map = renderMap(opts.options)

      /* set domain and scale */
      const maxHeight = opts.options.overlayOptions.maxHeight
      const domainValues = getDomainValues(opts.options.items)
      const yDomain = domainValues
      const scale = d3.scaleLinear().rangeRound([maxHeight, 0]).domain(yDomain)

      /* ID for setting and removing the animation loop */
      let refreshID

      /* render stations on map */
      const d3Layer = LeafletD3Layer((selection, projection) => {
        renderTriangles(selection, projection, opts.options.items, scale)

        /* redraw bars for torque effect  */
        refreshID = setInterval(function () {
          redraw(opts.options.items, scale, refreshID, projection)
        }, 300)
      })

      d3Layer.addTo(map)

      this.onSliderInput = (year) => {
        this.update({year})
        redraw(opts.options.items, scale, refreshID, map)
      }
    })

    function renderMap ({ center, zoom, tiles, attribution }) {
      const map = L.map('sealevel__map', { center, zoom })
      const tileLayer = L.tileLayer(tiles, { attribution })

      map.addLayer(tileLayer)
      map.zoomControl.setPosition('topleft')

      return map
    }

    function findTide ({ tideData }) {
      let tideObject = tideData.find(tideItem => tideItem.year === that.year)
      return tideObject && tideObject.tide
    }

    function getDomainValues (items) {
      let yMin = d3.min(items, function (station) {
        return d3.min(station.tideData, function (d) {
          return d.tide
        })
      })

      let yMax = d3.max(items, function (station) {
        return d3.max(station.tideData, function (d) {
          return d.tide
        })
      })

      return [yMin, yMax]
    }

    function renderTriangles (selection, projection, items, yScale) {
      /* parse data to get lat-long-coordinates and reformat timestamp */
      items.forEach(function (station) {
        station.LatLng = new L.LatLng(station.Latitude, station.Longitude)

        station.tideData.forEach(function (d) {
          d.year = parseTime(d.timestamp)
          d.year = d.year.getFullYear()
        })
      })

      selection.selectAll('path')
        .data(items)
        .enter().append('path')
        .attr('d', function (station) {
          if (findTide(station)) {
            let triangleHeight = Math.abs(yScale(findTide(station)) - yScale(0))
            if (findTide(station) >= 0) {
              return 'M 3,0 6,' + triangleHeight + ' 0,' + triangleHeight + ' z'
            } else {
              return 'M 0 0 L 3 ' + triangleHeight + ' L 6 0 z'
            }
          } else {
            return 'M 0 0 L 3 0 L 6 0 z'
          }
        })
        .attr('transform', function (station) {
          let x = projection.latLngToLayerPoint(station.LatLng).x - 3
          let yNeg = projection.latLngToLayerPoint(station.LatLng).y

          if (findTide(station)) {
            let triangleHeight = Math.abs(yScale(findTide(station)) - yScale(0))
            let yPos = projection.latLngToLayerPoint(station.LatLng).y - triangleHeight

            if (findTide(station) >= 0) {
              return 'translate(' + x + ',' + yPos + ')'
            } else {
              return 'translate(' + x + ',' + yNeg + ')'
            }
          } else {
            return 'translate(' + x + ',' + yNeg + ')'
          }
        })
        .on('click', function (station) {
          opts.onmarkerclick(station.ID)
          console.log('click')
        })
        .attr('class', function (station) {
          return findTide(station) < 0 ? 'negative' : 'positive'
        })
    }

    function redraw (data, scale, refreshID, map) {
      let yScale = scale
      let mapOverlay = d3.select('#sealevel__map').select('svg g')

      if (that.year < 2010) {
        that.update({ year: ++that.year })

        mapOverlay.selectAll('path')
          .data(data)
          .transition()
          .duration(150)
          .attr('d', function (station) {
            let triangleHeight
            if (findTide(station)) {
              triangleHeight = Math.abs(yScale(findTide(station)) - yScale(0))
              if (findTide(station) >= 0) {
                return 'M 3,0 6,' + triangleHeight + ' 0,' + triangleHeight + ' z'
              } else {
                return 'M 0 0 L 3 ' + triangleHeight + ' L 6 0 z'
              }
            } else {
              return 'M 0 0 L 3 0 L 6 0 z'
            }
          })
          .attr('transform', function (station) {
            let yNeg = map.latLngToLayerPoint(station.LatLng).y
            let x = map.latLngToLayerPoint(station.LatLng).x - 3

            if (findTide(station)) {
              let triangleHeight = Math.abs(yScale(findTide(station)) - yScale(0))
              let yPos = map.latLngToLayerPoint(station.LatLng).y - triangleHeight
              if (findTide(station) >= 0) {
                return 'translate(' + x + ',' + yPos + ')'
              } else {
                return 'translate(' + x + ',' + yNeg + ')'
              }
            } else {
              return 'translate(' + x + ',' + yNeg + ')'
            }
          })
          .attr('class', function (station) {
            return findTide(station) < 0 ? 'negative' : 'positive'
          })
      } else {
        clearInterval(refreshID)
      }
    }
  </script>
</sealevel-map>
