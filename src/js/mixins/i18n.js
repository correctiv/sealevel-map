import Polyglot from 'node-polyglot'
import _ from 'lodash'

import fr from 'json!../../locale/fr.json'
import de from 'json!../../locale/de.json'

export default function (language) {
  return {
    init: function () {
      const dictionaries = _.mapValues({ fr, de }, (phrases, locale) => (
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
