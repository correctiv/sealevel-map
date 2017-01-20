<sealevel-app>
  <sealevel-map onmarkerclick="{ handleMarkerClick }" onnextclick="{ showNext }" options="{ opts }" center="{ center }"></sealevel-map>

  <sealevel-details if="{ currentStation }" oncloseclick="{ handleCloseClick }" station="{ currentStation }"></sealevel-details>

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

    this.showNext = (id) => {
      this.handleMarkerClick(id)
    }

    function findStation (data, idToLookFor) {
      return data.filter(station => station.ID === idToLookFor)[0]
    }
  </script>
</sealevel-app>
