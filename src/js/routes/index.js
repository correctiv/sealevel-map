import route from 'riot-route'

export const STEPS = {
  EXPLORE: 'explore',
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
  route.start(true)
}

