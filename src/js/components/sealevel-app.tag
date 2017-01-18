<sealevel-app>
  <sealevel-map onmarkerclick="{ this.handleMarkerClick }" options="{ this.opts }" center="{ this.center }"></sealevel-map>

  <sealevel-details if="{ this.currentStation }" oncloseclick="{ this.handleCloseClick}" station="{ this.currentStation }"></sealevel-details>

  <script type="text/babel">
    this.currentStation = null

    this.handleMarkerClick = (id) => {
      const station = findStation(opts.items, id)
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

    function findStation (data, idToLookFor) {
      for (let i = 0; i < data.length; i++) {
        if (data[i].ID === idToLookFor) {
          return (data[i])
        }
      }
    }
  </script>

</sealevel-app>
