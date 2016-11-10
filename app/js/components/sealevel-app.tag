<sealevel-app class="st-container st-effect-1 {st-menu-open: currentStation}">

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
            station.Location = transformText(station.Location)
            this.update({
                currentStation: station
            })
        }

        function transformText(s) {
            return s.charAt(0) + s.slice(1).toLowerCase()
        }

        function findStation (data, idToLookFor) {
            for (var i = 0; i < data.length; i++) {
                if (data[i].ID == idToLookFor) {
                    return (data[i])
                }
            }
        }

    </script>

    <!-- content push wrapper -->
    <div class="st-pusher">

        <sealevel-map class="st-content" onmarkerclick="{ this.handleMarkerClick }" options="{ this.opts }"></sealevel-map>

        <sealevel-details if="{ this.currentStation }" oncloseclick="{ this.handleCloseClick}" station="{ this.currentStation }"></sealevel-details>

    </div>


</sealevel-app>