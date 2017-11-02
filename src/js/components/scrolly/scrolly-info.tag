<sealevel-scrolly-info class="scrolly__main--world-info">

  <div class="scrolly__main__wrapper">
    <div class="container">
      <div class="scrolly__main__content">

        <div class="scrolly__main__body">
          { i18n.t('scrolly.info') }
        </div>

        <figure class="scrolly__figure">

          <sealevel-linechart if={timeseries} series={ timeseries } />

          <figcaption class="scrolly__figure__caption">
            <p>{ i18n.t('scrolly.info_figcaption') }</p>
          </figcaption>
        </figure>

      </div>
    </div>
  </div>

  <script type="text/babel">
    import { requestStationList } from '../../actions/explorer'
    import '../linechart.tag'

    this.activeLayers = []
    this.state = this.store.getState()
    this.subscribe(state => this.update({ state }))

    this.on('mount', () => {
      this.store.dispatch(requestStationList())
    })

    this.on('update', () => {
      if (this.state.explorer.items) {
        this.timeseries = [{
          title: this.state.explorer.items[0].location,
          data: this.state.explorer.items[0].timeseries
        },
        {
          title: this.state.explorer.items[1].location,
          data: this.state.explorer.items[1].timeseries
        },
        {
          title: this.state.explorer.items[2].location,
          data: this.state.explorer.items[2].timeseries
        }]
      }
    })
  </script>

</sealevel-scrolly-info>
