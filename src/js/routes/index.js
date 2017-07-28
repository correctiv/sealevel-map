import route from 'riot-route'

export const STEPS = [
  'manila',
  'scandinavia',
  'france',
  'usa',
  'argentina'
]

export const intro = (locale) => `/${locale}/#intro`
export const article = (locale) => `/${locale}/#main`
export const explorer = (locale) => `/${locale}/explore`
export const continent = (locale, id) => `/${locale}/explore/${id}`
export const country = (locale, id) => `/${locale}/explore/countries/${id}`
export const station = (locale, id) => `/${locale}/explore/stations/${id}`

export const routeToIntro = (locale) => {
  route(explorer(locale))
}

export const routeToArticle = (locale) => {
  route(article(locale))
}

export const routeToExplorer = (locale) => {
  route(article(locale))
}

export const routeToContinent = (locale, id) => {
  route(continent(locale, id))
}

export const routeToCountry = (locale, id) => {
  route(country(locale, id))
}

export const routeToStation = (locale, id) => {
  route(station(locale, id))
}

