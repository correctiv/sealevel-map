import route from 'riot-route'

export const STEPS = {
  EXPERIMENT_1: 'titel-1',
  EXPERIMENT_2: 'titel-2',
  EXPLORE: 'explore'
}

export const continent = (locale, id) => `/${locale}/explore/${id}`
export const country = (locale, id) => `/${locale}/explore/countries/${id}`
export const station = (locale, id) => `/${locale}/explore/stations/${id}`

export const routeToContinent = (locale, id) => {
  route(continent(locale, id))
}

export const routeToCountry = (locale, id) => {
  route(country(locale, id))
}

export const routeToStation = (locale, id) => {
  route(station(id))
}

