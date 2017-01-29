<sealevel-map>

  <sealevel-map-slider if="{ this.next }" value="{ this.year }" oninput="{ this.onSliderInput }" class="slider"></sealevel-map-slider>

  <div if="{ this.opts.active === 0 }" class="sealevel__map__infobox">
    <p>FOO</p>
    <a href="#{this.opts.steps[1]}">Tell me more!</a>
  </div>

  <div if="{ this.opts.active === 1 }" class="sealevel__map__infobox">
    <p>BAR</p>
    <a href="#{this.opts.steps[2]}">Tell me more!</a>
  </div>

  <div if="{ this.opts.active === 2 }" class="sealevel__map__infobox">
    <p>BAZ</p>
    <a href="#{this.opts.steps[3]}">Tell me more!</a>
  </div>

  <div if="{ this.opts.active === 3 }" class="sealevel__map__infobox">
    <p>LOREM IPSUM</p>
    <a href="#{this.opts.steps[4]}">Tell me more!</a>
  </div>

  <div if="{ this.opts.active === 4 }" class="sealevel__map__infobox">
    <p>DOLOR SIT AMET</p>
    <a href="#{this.opts.steps[0]}">Tell me more!</a>
  </div>

  <div id="sealevel__map" class="sealevel__map"></div>

  <script type="text/babel">
    import L from 'leaflet'
    import 'leaflet_css'
    import 'leaflet_marker'
    import 'leaflet_marker_2x'
    import 'leaflet_marker_shadow'
    import tideOverTimeLayer from './tide-over-time-layer.js'
    import circleMarkerLayer from './circle-marker-layer.js'
    import animationData from '../../data/mapanimation.json'

    const MIN_YEAR = 1985
    const MAX_YEAR = 2014

    this.next = true

    this.go = function (e) {
      opts.onnextclick(1)
      this.update({
        next: false
      })
    }

    // cleanup resources after tag is no longer part of DOM
    this.on('updated', () => {
      switch (this.opts.active) {
        case 0:
          renderCircleMarkerLayer(this.map)
          break

        case 1:
          renderTideOverTimeLayer(this.map)
          break

        case 2:
          console.log('Do something on the third step!')
          break

        case 3:
          console.log('Do something on the fourth step!')
          break

        case 4:
          console.log('Do something on the fifth step!')
          break

        case 5:
          console.log('Do something on the sixth step!')
          break
      }
    })

    this.on('mount', () => {
      this.map = renderMap(opts.options)
    })

    function renderMap ({ center, zoom, tiles, attribution }) {
      const map = L.map('sealevel__map', { center, zoom })
      const tileLayer = L.tileLayer(tiles, { attribution })

      map.addLayer(tileLayer)
      map.zoomControl.setPosition('topleft')

      return map
    }

    function renderCircleMarkerLayer (map) {
      circleMarkerLayer.addTo(map, tideData, opts.onmarkerclick)
    }

    function renderTideOverTimeLayer (map) {
      const tideData = animationData
      let year = MIN_YEAR

      tideOverTimeLayer.addTo(map, tideData)

      /* redraw bars for torque effect  */
      const animationLoop = setInterval(() => {
        tideOverTimeLayer.redraw(year++)
        if (year > MAX_YEAR) clearInterval(animationLoop)
      }, 1000)
    }
  </script>
</sealevel-map>
