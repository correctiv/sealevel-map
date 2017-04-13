import Polyglot from 'node-polyglot'
import _ from 'lodash'

const translations = {
  'en': {
    'title': 'Rising seas',
    'read on': 'weiterlesen',
    'explorer': {
      'title': 'Explore',
      'choose a contintent': 'Choose a continent'
    }
  },
  'de': {
    'title': 'Steigende Meere',
    'read on': 'weiterlesen',
    'explorer': {
      'title': 'Explorer',
      'choose a contintent': 'Wähle einen Kontinent'
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
          return dictionaries[language].t(args)
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
