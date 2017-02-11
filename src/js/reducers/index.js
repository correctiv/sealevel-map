import { combineReducers } from 'redux'
import {
  SHOW_STATION_DETAILS,
  HIDE_STATION_DETAILS,
  REQUEST_STATION_DATA,
  RECEIVE_STATION_DATA,
  REQUEST_ANIMATION_DATA,
  RECEIVE_ANIMATION_DATA,
  SET_STEP
} from '../actions'

const explorerReducer = (state = {}, action) => {
  console.log(action)

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

const navigationReducer = (state = {
  activeStep: null
}, action) => {
  switch (action.type) {
    case SET_STEP:
      return {
        ...state,
        activeStep: action.id
      }
    default:
      return state
  }
}

const animationReducer = (state = {}, action) => {
  switch (action.type) {
    case REQUEST_ANIMATION_DATA:
      return {
        ...state,
        isFetching: true
      }
    case RECEIVE_ANIMATION_DATA:
      return {
        ...state,
        isFetching: false,
        items: action.data.stations
      }
    default:
      return state
  }
}

const rootReducer = combineReducers({
  navigation: navigationReducer,
  explorer: explorerReducer,
  animation: animationReducer
})

export default rootReducer
