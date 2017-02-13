import request from 'superagent'

export const SHOW_STATION_DETAILS = 'SHOW_STATION_DETAILS'
export const HIDE_STATION_DETAILS = 'HIDE_STATION_DETAILS'
export const REQUEST_STATION_DATA = 'REQUEST_STATION_DATA'
export const RECEIVE_STATION_DATA = 'RECEIVE_STATION_DATA'
export const REQUEST_ANIMATION_DATA = 'REQUEST_ANIMATION_DATA'
export const RECEIVE_ANIMATION_DATA = 'RECEIVE_ANIMATION_DATA'

// Animation data:

const shouldFetchData = (dataset) => (
  !dataset.isFetching || !dataset.items
)

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

const receiveStationData = (data) => ({
  type: RECEIVE_STATION_DATA,
  data
})

const requestStationData = () => ({
  type: REQUEST_STATION_DATA
})

const fetchStationData = (id) => dispatch => {
  dispatch(requestStationData())
  return request
    .get('data/dataexplorer.json')
    .then(({ body }) => {
      dispatch(receiveStationData(body.stations))
      // TODO: Load individual stations instead of filtering bulk data
      let station = findStation(body.stations, id)
      dispatch(showStationDetails(station))
    })
}

export const requestStationDetails = (id) => (dispatch, getState) => {
  if (shouldFetchData(getState().explorer)) {
    return dispatch(fetchStationData(id))
  } else {
    let station = findStation(getState().explorer.items, id)
    return dispatch(receiveStationData(station))
  }
}
