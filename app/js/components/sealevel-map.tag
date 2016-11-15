<sealevel-map>
    <div id="map" class="st-content-inner"></div>

    <script type="text/babel">

    import L from 'leaflet'

    this.on('mount', () => {
        const map = renderMap(opts.options)
        renderItems(map, opts.options)
    })

    function renderMap ( { center, zoom, tiles, attribution } ) {
        const map = L.map('map', { center, zoom })
        const tileLayer = L.tileLayer(tiles, { attribution })

        map.addLayer(tileLayer)
        map.zoomControl.setPosition('topleft')
        map.scrollWheelZoom.disable()
        return map
    }

    function renderItems (map, { items, icons, iconOptions } ) {
        const Icon = L.DivIcon.extend({ options: iconOptions })

        items.forEach(item => {

            const icon = new Icon( {className: 'map-marker '+ getIconClass(item)} )
            const lat = item.Latitude
            const long = item.Longitude
            const marker = L.marker([lat, long], {item, icon} )
            marker.addTo(map)

            /*marker.on("click", event => {
                handleMarkerClick(item.ID)
            })*/

            marker.on("click", event => {
                opts.onmarkerclick(item.ID)
            })
        })
    }

    function getIconClass(item) {
        var iconclass
        if (item.trend < -4) {
            iconclass = 'strong-decrease'
        }
        else if (item.trend >= -4 && item.trend < 0) {
            iconclass = 'decrease'
        }
        else if (item.trend >= 0 && item.trend <= 4) {
            iconclass = 'increase'
        }
        else if (item.trend > 4) {
            iconclass = 'strong-increase'
        }
        return iconclass

    }
    </script>
</sealevel-map>