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
    import L from 'leaflet'
    import 'leaflet_css'
    import 'leaflet_marker'
    import 'leaflet_marker_2x'
    import 'leaflet_marker_shadow'
    import tideOverTimeLayer from './tide-over-time-layer.js'

    const MIN_YEAR = 1807
    const MAX_YEAR = 2010

    this.next = true

    this.go = function (e) {
      opts.onnextclick(1)
      this.update({
        next: false
      })
    }

    this.on('mount', () => {
      /* render map */
      const map = renderMap(opts.options)
      const tideData = opts.options.items
      let year = MIN_YEAR

      tideOverTimeLayer.addTo(map, tideData)

      /* redraw bars for torque effect  */
      let animationLoop = setInterval(() => {
        tideOverTimeLayer.redraw(year++)
        if (year > MAX_YEAR) clearInterval(animationLoop)
      }, 300)

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
  </script>
</sealevel-map>
