<sealevel-details>

    <div class="st-menu st-effect-1">
        <p>Station ID: { opts.station.ID }</p>
        <p>Station Name: { opts.station.Location }</p>
        <p>Station Name: { opts.station.tideData[0].timestamp }</p>

        <button onclick={ opts.oncloseclick }>Close me!</button>

        <sealevel-linechart chartdata="{ this.opts.station.tideData }"></sealevel-linechart>

    </div>


</sealevel-details>