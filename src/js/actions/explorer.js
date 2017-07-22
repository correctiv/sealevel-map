import * as d3 from 'd3'
import _ from 'lodash'

export const SHOW_STATION_LIST = 'SHOW_STATION_LIST'
export const SHOW_STATION_DETAILS = 'SHOW_STATION_DETAILS'
export const HIDE_STATION_DETAILS = 'HIDE_STATION_DETAILS'
export const REQUEST_STATION_DETAILS_DATA = 'REQUEST_STATION_DETAILS_DATA'
export const RECEIVE_STATION_DETAILS_DATA = 'RECEIVE_STATION_DETAILS_DATA'
export const REQUEST_STATION_LIST_DATA = 'REQUEST_STATION_LIST_DATA'
export const RECEIVE_STATION_LIST_DATA = 'RECEIVE_STATION_LIST_DATA'

const CONTEXT_SRC = '/data/sealevel_context_data.csv'
const FULL_TIMESERIES_SRC = '/data/sealevel_viz_whole_timeseries.csv'
const TIMESERIES_SRC = '/data/sealevel_viz_psmsl_1985_2015.csv'

const shouldFetchOverviewData = ({ isFetchingOverviewData, items }) => (
  !isFetchingOverviewData || !items
)

const shouldFetchFullData = ({ isFetchingFullData, tides }) => (
  !isFetchingFullData || !tides
)

const prepareOverviewData = (context, timeseries) => {
  return _.map(timeseries, (item, id) => {
    const contextItem = _.find(context, { id })
    contextItem.timeseries = item.reduce((total, { year, tide }) => {
      total[year] = parseFloat(tide)
      return total
    }, [])
    return contextItem
  })
}

const prepareFullData = (timeseries) => {
  return _.mapValues(timeseries, (item, id) => {
    return _.map(item, ({ year, tide }) => ({
      tide: parseFloat(tide),
      year
    }))
  })
}

export const hideStationDetails = () => ({
  type: HIDE_STATION_DETAILS
})

const showStationDetails = (data) => ({
  type: SHOW_STATION_DETAILS,
  data
})

const receiveStationDetailsData = (data) => ({
  type: RECEIVE_STATION_DETAILS_DATA,
  data
})

const requestStationDetailsData = () => ({
  type: REQUEST_STATION_DETAILS_DATA
})

const fetchStationDetailsData = (id) => dispatch => {
  dispatch(requestStationDetailsData())

  d3.csv(FULL_TIMESERIES_SRC, (timeseries) => {
    const timeseriesById = _.groupBy(timeseries, 'id')
    const tides = prepareFullData(timeseriesById)

    dispatch(receiveStationDetailsData(tides))
    dispatch(showStationDetails(id))
  })
}

export const requestStationDetails = (id) => (dispatch, getState) => {
  if (shouldFetchFullData(getState().explorer)) {
    return dispatch(fetchStationDetailsData(id))
  } else {
    return dispatch(receiveStationDetailsData(id))
  }
}

const showStationList = ({ country, continent }) => ({
  type: SHOW_STATION_LIST,
  country,
  continent
})

const receiveStationListData = (data) => ({
  type: RECEIVE_STATION_LIST_DATA,
  data
})

const requestStationListData = () => ({
  type: REQUEST_STATION_LIST_DATA
})

const fetchStationListData = (options) => dispatch => {
  dispatch(requestStationListData())

  d3.csv(CONTEXT_SRC, (context) => {
    d3.csv(TIMESERIES_SRC, (timeseries) => {
      const timeseriesById = _.groupBy(timeseries, 'id')
      const stations = prepareOverviewData(context, timeseriesById)

      dispatch(receiveStationListData(stations))
      dispatch(showStationList(options))
    })
  })
}

export const requestStationList = (options = {}) => (dispatch, getState) => {
  if (shouldFetchOverviewData(getState().explorer)) {
    return dispatch(fetchStationListData(options))
  } else {
    return dispatch(showStationList(getState().explorer.items, options))
  }
}

