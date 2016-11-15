<sealevel-details>

    <div class="st-menu st-effect-1">
        <div class="close" onclick="{ opts.oncloseclick }">&#10006;</div>
        <h1>{ opts.station.Location } ({ opts.station.Country })</h1>
        <h2>First Measurement</h2>
        <p>Year: { this.year }<br/>
            Tide: { opts.station.tideData[0].tide }</p>
        <h2>Trend</h2>
        <p>Trend seit Messbeginn: 5 mm pro Jahr</p>
        <p>Trend seit 1960: 2 mm</p>
        <h2>C02-Emissionen von { opts.station.Country }</h2>

        <sealevel-linechart chartdata="{ this.opts.station.tideData }"></sealevel-linechart>

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