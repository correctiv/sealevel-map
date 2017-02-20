import route from 'riot-route'
import _ from 'lodash'
import { setStep } from '../actions/navigation'
import { requestStationDetails, requestStationList } from '../actions/explorer'

export const STEPS = {
  EXPLORER: 'explore',
  EXPERIMENT_1: 'experimental-animation-1',
  EXPERIMENT_2: 'experimental-animation-2'
}

export const continent = id => `explore/${id}`
export const country = id => `explore/countries/${id}`
export const station = id => `explore/stations/${id}`

export const routeToContinent = (id) => {
  route(continent(id))
}

export const routeToCountry = (id) => {
  route(country(id))
}

export const routeToStation = (id) => {
  route(station(id))
}

export const startRouting = (store) => {
  route('explore/stations/*', id => {
    store.dispatch(requestStationDetails(id))
    store.dispatch(setStep(STEPS.EXPLORER))
  })

  route('explore/countries/*', id => {
    store.dispatch(requestStationList({ country: id }))
  })

  route('explore/*', id => {
    store.dispatch(requestStationList({ continent: id }))
  })

  // initialize routes for main navigation:
  _.forEach(STEPS, slug => {
    route(slug, () => store.dispatch(setStep(slug)))
  })

  route.start(true)
}
