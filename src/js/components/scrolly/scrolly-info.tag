<sealevel-scrolly-info class="scrolly__main--world-info">

  <div class="scrolly__main__wrapper">
    <div class="container">
      <div class="scrolly__main__content">

        <div class="scrolly__main__body" ref="body">
        </div>

        <figure class="scrolly__figure scrolly__main__figure">

          <sealevel-linechart if={timeseries} series={ timeseries } />

          <figcaption class="scrolly__figure__caption">
            <p>{ i18n.t('scrolly.info_figcaption') }</p>
          </figcaption>
        </figure>

      </div>
    </div>
  </div>

  <script type="text/babel">
    import _ from 'lodash'
    import { requestStationList } from '../../actions/explorer'
    import '../linechart.tag'

    const stations = [{
      id: '180',
      title: 'Atlantic City'
    },
    {
      id: '61',
      title: 'Marseille'
    },
    {
      id: '1037',
      title: 'Borkum'
    },
    {
      id: '145',
      title: 'Manila'
    }]

    this.activeLayers = []
    this.state = this.store.getState()
    this.subscribe(state => this.update({ state }))

    this.on('mount', () => {
      this.store.dispatch(requestStationList())
    })

    this.on('update', () => {
      const items = this.state.explorer.items
      const lang = this.i18n.getLocale()
      const body = require(`../../../locale/${lang}/info.md`)
      this.refs.body.innerHTML = body

      if (items) {
        this.timeseries = stations.map(({id, title}) => ({
          title,
          data: _.find(items, {id}).timeseries
        }))
      }
    })
  </script>

</sealevel-scrolly-info>
