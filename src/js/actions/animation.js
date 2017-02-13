import request from 'superagent'

export const REQUEST_ANIMATION_DATA = 'REQUEST_ANIMATION_DATA'
export const RECEIVE_ANIMATION_DATA = 'RECEIVE_ANIMATION_DATA'

const shouldFetchData = (dataset) => (
  !dataset.isFetching || !dataset.items
)

const receiveAnimationData = (data) => ({
  type: RECEIVE_ANIMATION_DATA,
  data
})

const requestAnimationData = () => ({
  type: REQUEST_ANIMATION_DATA
})

const fetchAnimationData = () => dispatch => {
  dispatch(requestAnimationData())
  return request
    .get('data/mapanimation.json')
    .then(({ body }) => {
      dispatch(receiveAnimationData(body))
    })
}

export const fetchAnimationDataIfNeeded = () => (dispatch, getState) => {
  if (shouldFetchData(getState().animation)) {
    return dispatch(fetchAnimationData())
  }
}
