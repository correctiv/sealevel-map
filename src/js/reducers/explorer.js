import {
  REQUEST_STATION_LIST_DATA,
  RECEIVE_STATION_LIST_DATA,
  REQUEST_STATION_DETAILS_DATA,
  RECEIVE_STATION_DETAILS_DATA,
  SHOW_STATION_DETAILS,
  SHOW_STATION_LIST
} from '../actions/explorer'

const explorerReducer = (state = {}, action) => {
  console.log(action.type, action)

  switch (action.type) {
    case REQUEST_STATION_LIST_DATA:
      return {
        ...state,
        isFetchingOverviewData: true
      }
    case RECEIVE_STATION_LIST_DATA:
      return {
        ...state,
        items: action.data,
        isFetchingOverviewData: false
      }
    case REQUEST_STATION_DETAILS_DATA:
      return {
        ...state,
        isFetchingFullData: true
      }
    case RECEIVE_STATION_DETAILS_DATA:
      return {
        ...state,
        tides: action.data,
        isFetchingFullData: false
      }
    case SHOW_STATION_DETAILS:
      return {
        ...state,
        station: action.data,
        country: null,
        continent: null
      }
    case SHOW_STATION_LIST:
      return {
        ...state,
        station: null,
        country: action.country,
        continent: action.continent
      }
    default:
      return state
  }
}

export default explorerReducer
