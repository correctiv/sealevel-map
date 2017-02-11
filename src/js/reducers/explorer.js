import {
  SHOW_STATION_DETAILS,
  HIDE_STATION_DETAILS,
  REQUEST_STATION_DATA,
  RECEIVE_STATION_DATA
} from '../actions'

const explorerReducer = (state = {}, action) => {
  switch (action.type) {
    case REQUEST_STATION_DATA:
      return {
        ...state,
        isFetching: true
      }
    case RECEIVE_STATION_DATA:
      return {
        ...state,
        isFetching: false,
        items: action.data.stations
      }
    case SHOW_STATION_DETAILS:
      return {
        ...state,
        currentStation: action.data
      }
    case HIDE_STATION_DETAILS:
      return {
        ...state,
        currentStation: null
      }
    default:
      return state
  }
}

export default explorerReducer
