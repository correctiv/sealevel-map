<sealevel-details>

    <div class="sealevel__details">
        <div class="sealevel__details__close" onclick="{ opts.oncloseclick }">&#10006;</div>
        <h1 class="sealevel__details__titel">{ opts.station.Location }</h1>
        <p>Country: { opts.station.Country }</p>
        <h3>Trend</h3>
        <p>{ opts.station.trend } mm per year</p>

        <sealevel-linechart chartdata="{ this.opts.station.tideData }"></sealevel-linechart>

        <h3>CO2 emissions of { opts.station.Country }</h3>
        <p>{ opts.station.emission.toFixed(2) } metric tons per capita</h3></p>

    </div>

    <script type="text/babel">

        this.on('update', () => {
            if (this.opts.station) {
            var getYear = new Date(this.opts.station.tideData[0].timestamp)
            var currentYear = getYear.getFullYear()
            this.update({
                year: currentYear
            })
        }
        })


    </script>


</sealevel-details>