export const SHOW_STATION_DETAILS = 'SHOW_STATION_DETAILS'
export const HIDE_STATION_DETAILS = 'HIDE_STATION_DETAILS'
export const EXPLORER_DATA_LOADED = 'EXPLORER_DATA_LOADED'

export const showStationDetails = (id) => ({
  type: SHOW_STATION_DETAILS,
  id
})

export const hideStationDetails = () => ({
  type: HIDE_STATION_DETAILS
})

export const loadExplorerData = () => {
  return (dispatch, getState) => {
    let request = new XMLHttpRequest()
    request.open('GET', 'data/dataexplorer.json', true)
    request.onload = () => {
      if (request.status >= 200 && request.status < 400) {
        let data = JSON.parse(request.responseText)
        dispatch(explorerDataLoaded(data))
      }
    }
    request.send()
  }
}

const explorerDataLoaded = (data) => ({
  type: EXPLORER_DATA_LOADED,
  data
})
