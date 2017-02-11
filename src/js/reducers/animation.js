import {
  REQUEST_ANIMATION_DATA,
  RECEIVE_ANIMATION_DATA
} from '../actions'

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

export default animationReducer
