import Polyglot from 'node-polyglot'
import _ from 'lodash'

const translations = {
  'en': {
    'intro': {
      'title': 'Rising Seas',
      'lead': 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim consectetur adipisicing elit sed do.',
      'more': 'read more',
      'logo_alt': 'a project by CORRECTIV'
    },
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
      'num_stations': '%{smart_count} station |||| %{smart_count} stations',
      'station_description': 'In %{ location } sea level %{ sealevel_change_short }  yearly around %{ trend_1985_2015 } mm between 1985 and 2015. Since the very beginning of measurements in %{ start_year }, sea level %{ sealevel_change_long } yearly around %{ trend_longest }.'
    }
  },
  'de': {
    'intro': {
      'title': 'Steigende Meere',
      'lead': 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim consectetur adipisicing elit sed do.',
      'more': 'mehr erfahren',
      'logo_alt': 'ein Projekt von CORRECTIV'
    },
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
      'num_stations': '%{smart_count} Station |||| %{smart_count} Stationen',
      'station_desc_rising': 'In %{location}, the sea level rose yearly around %{trend_1985_2015}mm between 1985 and 2015. Since the very beginning of measurements in %{start_year}, sea level rose yearly around %{trend_longest}mm.',
      'station_desc_falling': 'In %{location}, the sea level fell yearly around %{trend_1985_2015}mm between 1985 and 2015. Since the very beginning of measurements in %{start_year}, sea level fell yearly around %{trend_longest}mm.',
      'risk_desc': 'In %{country_name}, %{coastal_population2010_sum} people of the %{total_population} population live in coastal regions. According to World Risk Index, %{country_name} has a %{risk_description}  risk ( %{risk_index} ) to be affected by a natural disaster.',
      'emissions_desc': 'According to calculations of the United Nations, each person is allowed to emit two tonnes of C02 per year in order to keep global warming below two degrees. %{country_name} emits %{c02_emissions} tonnes of C02 emissions per person. On the global rank of largest C02 emissions per person, %{country_name} is placed on rank %{c02_rank}.'
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
