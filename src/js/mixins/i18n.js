import Polyglot from 'node-polyglot'
import _ from 'lodash'

const translations = {
  'en': {
    'title': 'Rising seas',
    'read on': 'weiterlesen',
    'explorer': {
      'title': 'Explore',
      'choose_continent': 'Choose a continent',
      'start': 'Start',
      'continents': {
        'africa': 'Africa',
        'north-america': 'North America',
        'south-america': 'South America',
        'asia': 'Asia',
        'europe': 'Europe',
        'oceania': 'Australia and Oceania'
      },
      'countries': {
        'FRA': 'FRA',
        'GBR': 'GBR',
        'DEU': 'DEU',
        'NLD': 'NLD',
        'USA': 'USA',
        'FIN': 'FIN',
        'NOR': 'NOR',
        'GEO': 'GEO',
        'SWE': 'SWE',
        'DNK': 'DNK',
        'CAN': 'CAN',
        'AUS': 'AUS',
        'LTU': 'LTU',
        'JPN': 'JPN',
        'NZL': 'NZL',
        'PHL': 'PHL',
        'ITA': 'ITA',
        'PAN': 'PAN',
        'THA': 'THA',
        'IND': 'IND',
        'RUS': 'RUS',
        'MYS': 'MYS',
        'ALA': 'ALA',
        'PRT': 'PRT',
        'HRV': 'HRV',
        'BMU': 'BMU',
        'GRC': 'GRC',
        'BEL': 'BEL',
        'URY': 'URY',
        'ESP': 'ESP',
        'CHL': 'CHL',
        'MHL': 'MHL',
        'UMI': 'UMI',
        'ASM': 'ASM',
        'GUM': 'GUM',
        'SJM': 'SJM',
        'CUB': 'CUB',
        'ISL': 'ISL',
        'CHN': 'CHN',
        'SGP': 'SGP',
        'PRI': 'PRI',
        'ARG': 'ARG',
        'ZAF': 'ZAF',
        'VNM': 'VNM',
        'ATA': 'ATA',
        'KOR': 'KOR',
        'BRA': 'BRA',
        'PLW': 'PLW',
        'PYF': 'PYF',
        'PER': 'PER',
        'FJI': 'FJI',
        'KIR': 'KIR',
        'FSM': 'FSM',
        'VIR': 'VIR',
        'COK': 'COK',
        'MNP': 'MNP',
        'REU': 'REU',
        'TZA': 'TZA',
        'ECU': 'ECU'
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
      'start': 'Start',
      'continents': {
        'africa': 'Afrika',
        'north-america': 'Nordamerika',
        'south-america': 'Südamerika',
        'asia': 'Asien',
        'europe': 'Europa',
        'oceania': 'Australien und Ozeanien'
      },
      'countries': {
        'FRA': 'FRA',
        'GBR': 'GBR',
        'DEU': 'DEU',
        'NLD': 'NLD',
        'USA': 'USA',
        'FIN': 'FIN',
        'NOR': 'NOR',
        'GEO': 'GEO',
        'SWE': 'SWE',
        'DNK': 'DNK',
        'CAN': 'CAN',
        'AUS': 'AUS',
        'LTU': 'LTU',
        'JPN': 'JPN',
        'NZL': 'NZL',
        'PHL': 'PHL',
        'ITA': 'ITA',
        'PAN': 'PAN',
        'THA': 'THA',
        'IND': 'IND',
        'RUS': 'RUS',
        'MYS': 'MYS',
        'ALA': 'ALA',
        'PRT': 'PRT',
        'HRV': 'HRV',
        'BMU': 'BMU',
        'GRC': 'GRC',
        'BEL': 'BEL',
        'URY': 'URY',
        'ESP': 'ESP',
        'CHL': 'CHL',
        'MHL': 'MHL',
        'UMI': 'UMI',
        'ASM': 'ASM',
        'GUM': 'GUM',
        'SJM': 'SJM',
        'CUB': 'CUB',
        'ISL': 'ISL',
        'CHN': 'CHN',
        'SGP': 'SGP',
        'PRI': 'PRI',
        'ARG': 'ARG',
        'ZAF': 'ZAF',
        'VNM': 'VNM',
        'ATA': 'ATA',
        'KOR': 'KOR',
        'BRA': 'BRA',
        'PLW': 'PLW',
        'PYF': 'PYF',
        'PER': 'PER',
        'FJI': 'FJI',
        'KIR': 'KIR',
        'FSM': 'FSM',
        'VIR': 'VIR',
        'COK': 'COK',
        'MNP': 'MNP',
        'REU': 'REU',
        'TZA': 'TZA',
        'ECU': 'ECU'
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
