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

const shouldFetchOverviewData = ({ isFetchingOverviewData, items }) => (
  !(isFetchingOverviewData || items)
)

const shouldFetchFullData = ({ isFetchingFullData, tides }) => (
  !(isFetchingFullData || tides)
)

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

const prepareFullData = (timeseries) => {
  return _.mapValues(timeseries, (tides) => {
    return _(tides[0])
      .pickBy((value, key) => !isNaN(key) && value)
      .map((tide, year) => ({
        tide: parseFloat(tide),
        year
      }))
      .value()
  })
}

const fetchStationDetailsData = (id) => dispatch => {
  dispatch(requestStationDetailsData())

  d3.csv(FULL_TIMESERIES_SRC, (timeseries) => {
    const tidesById = _.groupBy(timeseries, 'id')
    const tides = prepareFullData(tidesById)
    dispatch(receiveStationDetailsData(tides))
    dispatch(showStationDetails(id))
  })
}

const requestStationDetails = (id) => (dispatch, getState) => {
  if (shouldFetchFullData(getState().explorer)) {
    return dispatch(fetchStationDetailsData(id))
  } else {
    return dispatch(showStationDetails(id))
  }
}

const showStationList = ({ country, continent, station }) => ({
  type: SHOW_STATION_LIST,
  country,
  continent,
  station
})

const receiveStationListData = (data) => ({
  type: RECEIVE_STATION_LIST_DATA,
  data
})

const requestStationListData = () => ({
  type: REQUEST_STATION_LIST_DATA
})

const prepareOverviewData = (stations) => {
  return _.map(stations, (station, id) => ({
    c02_emissions: station.c02_emissions,
    coastal_population2010_sum: station.coastal_population2010_sum,
    continent: station.continent,
    country: station.country,
    id: station.id,
    latitude: station.latitude,
    location: station.location,
    longitude: station.longitude,
    total_population2010_sum: station.total_population2010_sum,
    trend_1985_2015: station.trend_1985_2015,
    trend_longest: station.trend_longest,
    timeseries: _(station)
      .pickBy((value, key) => !isNaN(key) && value)
      .reduce((result, tide, year) => {
        result[year] = parseFloat(tide)
        return result
      }, [])
  }))
}

const fetchStationListData = (options) => dispatch => {
  dispatch(requestStationListData())

  d3.csv(CONTEXT_SRC, (context) => {
    const stations = prepareOverviewData(context)
    dispatch(receiveStationListData(stations))
    dispatch(showStationList(options))
  })
}

export const requestStationList = (options = {}) => (dispatch, getState) => {
  if (shouldFetchOverviewData(getState().explorer)) {
    dispatch(fetchStationListData(options))
  } else {
    dispatch(showStationList(options))
  }

  if (options.station) {
    dispatch(requestStationDetails(options.station))
  }
}

