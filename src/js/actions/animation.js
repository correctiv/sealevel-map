import * as d3 from 'd3'
import _ from 'lodash'

export const REQUEST_ANIMATION_DATA = 'REQUEST_ANIMATION_DATA'
export const RECEIVE_ANIMATION_DATA = 'RECEIVE_ANIMATION_DATA'

const CONTEXT_SRC = '/data/sealevel_context_data.csv'
const TIMESERIES_SRC = '/data/sealevel_viz_whole_timeseries.csv'
// const TIMESERIES_SRC = '/data/sealevel_viz_psmsl_1985_2015.csv'

const shouldFetchData = dataset => (
  !dataset.isFetching || !dataset.items
)

const prepareAnimationData = (context, timeseries) => {
  return _.map(timeseries, (item, id) => {
    const contextItem = _.find(context, { id })
    return ({
      lngLat: [contextItem.longitude, contextItem.latitude],
      timeseries: item.reduce((total, { year, tide }) => {
        total[year] = parseFloat(tide)
        return total
      }, [])
    })
  })
}

const receiveAnimationData = (data) => ({
  type: RECEIVE_ANIMATION_DATA,
  data
})

const requestAnimationData = () => ({
  type: REQUEST_ANIMATION_DATA
})

const fetchAnimationData = () => dispatch => {
  dispatch(requestAnimationData())

  d3.csv(CONTEXT_SRC, (context) => {
    d3.csv(TIMESERIES_SRC, (timeseries) => {
      const timeseriesById = _.groupBy(timeseries, 'id')
      const animationData = prepareAnimationData(context, timeseriesById)

      return dispatch(receiveAnimationData(animationData))
    })
  })
}

export const fetchAnimationDataIfNeeded = () => (dispatch, getState) => {
  if (shouldFetchData(getState().animation)) {
    return dispatch(fetchAnimationData())
  }
}
