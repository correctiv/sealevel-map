import { combineReducers } from 'redux'
import navigationReducer from './navigation.js'
import explorerReducer from './explorer.js'
import animationReducer from './animation.js'

const rootReducer = combineReducers({
  navigation: navigationReducer,
  explorer: explorerReducer,
  animation: animationReducer
})

export default rootReducer
