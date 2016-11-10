<sealevel-map>
    <div id="map" class="st-content-inner"></div>

    <script type="text/babel">

    import L from 'leaflet'

    this.on('mount', () => {
        const map = renderMap(opts.options)
        renderItems(map, opts.options)
    })

   /* const handleMarkerClick = (id) => {
        this.trigger('markerClick', id)
    }*/

    function renderMap ( { center, zoom, tiles, attribution } ) {
        const map = L.map('map', { center, zoom })
        const tileLayer = L.tileLayer(tiles, { attribution })

        map.addLayer(tileLayer)
        map.zoomControl.setPosition('topleft')
        map.scrollWheelZoom.disable()
        return map
    }

    function renderItems (map, { items, icons, iconOptions } ) {
        const Icon = L.Icon.extend({ options: iconOptions })

        items.forEach(item => {
            const icon = new Icon({ iconUrl: icons[item.rise] })
            const lat = item.Latitude
            const long = item.Longitude
            const marker = L.marker([lat, long], { icon, item } )
            marker.addTo(map)

            /*marker.on("click", event => {
                handleMarkerClick(item.ID)
            })*/

            marker.on("click", event => {
                opts.onmarkerclick(item.ID)

            })
        })
    }
    </script>
</sealevel-map>