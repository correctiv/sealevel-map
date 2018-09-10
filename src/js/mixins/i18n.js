import Polyglot from 'node-polyglot'
import _ from 'lodash'

import en from 'json!../../locale/en/locale.json'
import fr from 'json!../../locale/fr/locale.json'
import de from 'json!../../locale/de/locale.json'
import ko from 'json!../../locale/ko/locale.json'

export default function (language) {
  return {
    init: function () {
      const dictionaries = _.mapValues({ en, fr, de, ko }, (phrases, locale) => (
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
