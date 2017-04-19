import * as d3 from 'd3'
import request from 'superagent'

export const SHOW_STATION_LIST = 'SHOW_STATION_LIST'
export const SHOW_STATION_DETAILS = 'SHOW_STATION_DETAILS'
export const HIDE_STATION_DETAILS = 'HIDE_STATION_DETAILS'
export const REQUEST_STATION_DETAILS_DATA = 'REQUEST_STATION_DETAILS_DATA'
export const RECEIVE_STATION_DETAILS_DATA = 'RECEIVE_STATION_DETAILS_DATA'
export const REQUEST_STATION_LIST_DATA = 'REQUEST_STATION_LIST_DATA'
export const RECEIVE_STATION_LIST_DATA = 'RECEIVE_STATION_LIST_DATA'

// Explorer data:

const shouldFetchData = ({ isFetching, items }) => !isFetching || !items

export const hideStationDetails = () => ({
  type: HIDE_STATION_DETAILS
})

const showStationDetails = (data) => ({
  type: SHOW_STATION_DETAILS,
  data
})

const findStation = (data, id) => {
  return data.find(({ID}) => ID.toString() === id.toString())
}

const receiveStationDetailsData = (data) => ({
  type: RECEIVE_STATION_DETAILS_DATA,
  data
})

const requestStationDetailsData = () => ({
  type: REQUEST_STATION_DETAILS_DATA
})

const fetchStationDetailsData = (id) => dispatch => {
  dispatch(requestStationDetailsData())
  // TODO: Load individual stations instead of loading and filtering bulk data
  return request
    .get('/data/dataexplorer.json')
    .then(({ body }) => {
      dispatch(receiveStationDetailsData())
      let station = findStation(body.stations, id)
      dispatch(showStationDetails(station))
    })
}

export const requestStationDetails = (id) => (dispatch, getState) => {
  if (shouldFetchData(getState().explorer)) {
    return dispatch(fetchStationDetailsData(id))
  } else {
    let station = findStation(getState().explorer.items, id)
    return dispatch(receiveStationDetailsData(station))
  }
}

const showStationList = (data, { country, continent }) => ({
  type: SHOW_STATION_LIST,
  data,
  country,
  continent
})

const receiveStationListData = () => ({
  type: RECEIVE_STATION_LIST_DATA
})

const requestStationListData = () => ({
  type: REQUEST_STATION_LIST_DATA
})

const fetchStationListData = (options) => dispatch => {
  dispatch(requestStationListData())

  d3.csv('/data/sealevel_context_data.csv', (stations) => {
    dispatch(receiveStationListData())
    dispatch(showStationList(stations, options))
  })
}

export const requestStationList = (options = {}) => (dispatch, getState) => {
  if (shouldFetchData(getState().explorer)) {
    return dispatch(fetchStationListData(options))
  } else {
    return dispatch(showStationList(getState().explorer.items, options))
  }
}
