<sealevel-map>
    <div id="sealevel__map" class="sealevel__map"></div>

    <script type="text/babel">

        import L from 'leaflet'


        this.on('mount', () => {
            const map = renderMap(opts.options)
            renderItems(map, opts.options)
        })

        function renderMap ( { center, zoom, tiles, attribution } ) {
            const map = L.map('sealevel__map', { center, zoom })
            const tileLayer = L.tileLayer(tiles, { attribution })

            map.addLayer(tileLayer)
            map.zoomControl.setPosition('topleft')
            map.scrollWheelZoom.disable()
            return map
        }

        function renderItems (map, { items, icons, iconOptions } ) {
            const Icon = L.DivIcon.extend({ options: iconOptions })

            items.forEach(item => {

                const icon = new Icon( {className: 'sealevel__map__marker '+ getIconClass(item)} )
                const coordinates = [item.Latitude, item.Longitude]
                const marker = L.marker(coordinates, {item, icon} )
                marker.addTo(map)

                marker.bindPopup(item.Location)
                marker.on('mouseover', function (e) {
                    this.openPopup()
                })
                marker.on('mouseout', function (e) {
                    this.closePopup()
                })

                marker.on("click", event => {
                    opts.onmarkerclick(item.ID)
                    map.setZoomAround(coordinates, 5)
                    //document.body.classList.remove('selected')
                    //marker._icon.classList.add('selected')
                    //marker._icon.className += ' selected'
                })
            })
        }

        function getIconClass(item) {
            var iconclass = "sealevel__map__marker--"
            if (item.trend < -4) {
                iconclass += 'strong-decrease'
            }
            else if (item.trend >= -4 && item.trend < 0) {
                iconclass += 'decrease'
            }
            else if (item.trend >= 0 && item.trend <= 4) {
                iconclass += 'increase'
            }
            else if (item.trend > 4) {
                iconclass += 'strong-increase'
            }
            return iconclass

        }
    </script>
</sealevel-map>