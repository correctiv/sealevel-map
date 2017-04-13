import Polyglot from 'node-polyglot'
import _ from 'lodash'

const translations = {
  'en': {
    'title': 'Rising seas',
    'read on': 'weiterlesen',
    'explorer': {
      'title': 'Explore',
      'choose_continent': 'Choose a continent',
      'continents': {
        'africa': 'Africa',
        'north-america': 'North America',
        'south-america': 'South America',
        'asia': 'Asia',
        'europe': 'Europe',
        'oceania': 'Australia and Oceania'
      },
      'num_stations': '%{smart_count} station |||| %{smart_count} stations'
    }
  },
  'de': {
    'title': 'Steigende Meere',
    'read on': 'weiterlesen',
    'explorer': {
      'title': 'Explorer',
      'choose_continent': 'Wähle einen Kontinent',
      'continents': {
        'africa': 'Afrika',
        'north-america': 'Nordamerika',
        'south-america': 'Südamerika',
        'asia': 'Asien',
        'europe': 'Europa',
        'oceania': 'Australien und Ozeanien'
      },
      'num_stations': '%{smart_count} Station |||| %{smart_count} Stationen'
    }
  }
}

export default function (language) {
  return {
    init: function () {
      const dictionaries = _.mapValues(translations, (phrases, locale) => (
        new Polyglot({ phrases, locale })
      ))

      this.i18n = {
        t: (...args) => {
          return dictionaries[language].t(...args)
        },
        setLocale: (locale) => {
          language = locale
        },
        getLocale: () => {
          return language
        }
      }
    }
  }
}
