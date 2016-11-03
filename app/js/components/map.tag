<map>
    <div id="map"></div>

    <script type="text/babel">

    import L from 'leaflet'

    this.on('mount', () => {
        const center = [40.737, -73.923]
        const zoom = 13
        const tiles = 'http://{s}.tile.osm.org/{z}/{x}/{y}.png'
        const attribution = '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
        const map = renderMap(center, zoom, tiles, attribution)

    })

    function renderMap (center, zoom, tiles, attribution) {
        const map = L.map('map', { center, zoom })
        const tileLayer = L.tileLayer(tiles, { attribution })

        map.addLayer(tileLayer)
        map.zoomControl.setPosition('topleft')
        map.scrollWheelZoom.disable()

        return map
    }

    </script>
</map>