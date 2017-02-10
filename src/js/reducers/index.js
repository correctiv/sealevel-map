import { SHOW_STATION_DETAILS, HIDE_STATION_DETAILS, EXPLORER_DATA_LOADED } from '../actions'

const initialState = {
  currentStation: null,
  explorerData: []
}

const findStation = (data, id) => {
  return data.find(({ID}) => ID.toString() === id.toString())
}

export default (state = initialState, action) => {
  console.log(action)

  switch (action.type) {
    case EXPLORER_DATA_LOADED:
      return { ...state, explorerData: action.data.stations }

    case SHOW_STATION_DETAILS:
      let station = findStation(state.explorerData, action.id)
      return { ...state, currentStation: station }

    case HIDE_STATION_DETAILS:
      return { ...state, currentStation: null }

    default:
      return state
  }
}
