<sealevel-map-slider>

  <div>{ opts.value }</div>

  <label for="sealevel-range-input">1807</label>
  <input name="sealevel-range-input"
       id="sealevel-range-input"
       type="range" orient="vertical"
       min="1807" max="2010" value="{ opts.value }"
       oninput={ onInput } />
  <label for="sealevel-range-input">2010</label>

  <script type="text/babel">
    this.onInput = (event) => {
      event.stopPropagation()
      this.opts.oninput(event.target.value)
    }

    console.log(opts.value)
  </script>

</sealevel-map-slider>
