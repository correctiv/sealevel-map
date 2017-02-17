import route from 'riot-route'
import { setStep } from '../actions/navigation'
import { requestStationDetails, requestStationList } from '../actions/explorer'

export const steps = [
  '',
  'experimental-animation-1',
  'experimental-animation-2'
]

export const continent = id => `continents/${id}`
export const country = id => `countries/${id}`
export const station = id => `stations/${id}`

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
  route(slug => {
    const activeStep = steps.indexOf(slug)
    if (activeStep >= 0) {
      store.dispatch(setStep(activeStep))
    }
  })

  route('stations/*', id => {
    store.dispatch(requestStationDetails(id))
  })

  route('countries', () => {
    store.dispatch(requestStationList())
  })

  route('countries/*', id => {
    store.dispatch(requestStationList({ country: id }))
  })

  route('continents/*', id => {
    store.dispatch(requestStationList({ continent: id }))
  })

  route.start(true)
}

