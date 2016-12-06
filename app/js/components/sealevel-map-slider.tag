<sealevel-map-slider>

    <label for="sealevel-range-input">1807</label>
    <input name="sealevel-range-input"
           id="sealevel-range-input"
           type="range" orient="vertical"
           min="1807" max="2010"
           oninput={ onInput } />
    <label for="sealevel-range-input">2010</label>

    <script type="text/babel">
    this.onInput = (event) => {
      event.stopPropagation()
      this.opts.oninput(event.target.value)
    }
  </script>

</sealevel-map-slider>