import request from 'superagent'

export const SHOW_STATION_DETAILS = 'SHOW_STATION_DETAILS'
export const HIDE_STATION_DETAILS = 'HIDE_STATION_DETAILS'
export const EXPLORER_DATA_LOADED = 'EXPLORER_DATA_LOADED'
export const ANIMATION_DATA_LOADED = 'ANIMATION_DATA_LOADED'

export const showStationDetails = (id) => ({
  type: SHOW_STATION_DETAILS,
  id
})

export const hideStationDetails = () => ({
  type: HIDE_STATION_DETAILS
})

export const loadAnimationData = () => {
  return (dispatch, getState) => {
    request
      .get('data/mapanimation.json')
      .end((error, { body }) => {
        if (error) {
          console.error(error)
        } else {
          dispatch(animationDataLoaded(body))
        }
      })
  }
}

export const loadExplorerData = () => {
  return (dispatch, getState) => {
    request
      .get('data/dataexplorer.json')
      .end((error, { body }) => {
        if (error) {
          console.error(error)
        } else {
          dispatch(explorerDataLoaded(body))
        }
      })
  }
}

const explorerDataLoaded = (data) => ({
  type: EXPLORER_DATA_LOADED,
  data
})

const animationDataLoaded = (data) => ({
  type: ANIMATION_DATA_LOADED,
  data
})
