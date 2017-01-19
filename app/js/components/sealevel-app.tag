<sealevel-app>
    <sealevel-map onmarkerclick="{ this.handleMarkerClick }" onnextclick="{ this.showNext }" options="{ this.opts }" center="{ this.center }"></sealevel-map>

    <sealevel-details if="{ this.currentStation }" oncloseclick="{ this.handleCloseClick}" station="{ this.currentStation }"></sealevel-details>

    <script type="text/babel">

        this.currentStation = null

        this.handleMarkerClick = (id) => {
            var station = findStation(opts.items, id)
            this.updateStations(station)
        }

        this.handleCloseClick = () => {
            this.update({
                currentStation: null
            })
        }

        this.updateStations = (station) => {
            this.update({
                currentStation: station
            })
        }

        this.showNext = (id) => {
            this.update({
                currentStation: id
            })
        }

        function findStation (data, idToLookFor) {
            for (var i = 0; i < data.length; i++) {
                if (data[i].ID == idToLookFor) {
                    return (data[i])
                }
            }
        }

    </script>


</sealevel-app>