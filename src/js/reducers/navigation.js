import { SET_STEP } from '../actions'

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

export default navigationReducer
