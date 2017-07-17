import {
  REQUEST_ANIMATION_DATA,
  RECEIVE_ANIMATION_DATA
} from '../actions/animation'

const animationReducer = (state = {}, action) => {
  switch (action.type) {
    case REQUEST_ANIMATION_DATA:
      return {
        ...state,
        isFetching: true,
        items: []
      }
    case RECEIVE_ANIMATION_DATA:
      return {
        ...state,
        isFetching: false,
        items: action.data
      }
    default:
      return state
  }
}

export default animationReducer
