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

            const triangleUp = '50 0 100 234 0 234'
            const triangleDown = '50 0 100 234 0 234'
            //const triangleDown = '0 0 100 0 50 234'

            const svgPoints = item.trend < 0 ? triangleDown : triangleUp

            let svgIcon = `
                <?xml version="1.0" encoding="UTF-8" standalone="no"?>
                <svg height="100%" viewBox="0 0 100 234" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                    <g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                        <polygon fill="#D8D8D8" points="${ svgPoints }"></polygon>
                    </g>
                </svg>`

            const icon = new Icon( {className: 'sealevel__map__marker '+ getIconClass(item), html: svgIcon})

            //icon.options.iconSize = [getIconHeight(item), getIconHeight(item)]

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

    /*function getIconHeight(item) {
        var height
        if (item.trend < -8) {
            height = 40
        }
        else if (item.trend >= -8 && item.trend < -4) {
            height = 30
        }
        else if (item.trend >= -4 && item.trend < 0) {
            height = 20
        }
        else if (item.trend >= 0 && item.trend <= 4) {
            height = 20
        }
        else if (item.trend > 4 && item.trend <= 8) {
            height = 30
        }
        else if (item.trend > 8) {
            height = 40
        }
        return height

    }*/
    </script>
</sealevel-map>