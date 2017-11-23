import PiwikTracker from 'piwik-tracker'
import config from 'json!../config/main.json'

export default function () {
  const piwik = new PiwikTracker(config.piwik.id, config.piwik.url)
  let currentUrl

  return {
    init: function () {
      this.on('route', () => {
        // track if URL changed since last `route` event:
        if (currentUrl !== window.location.href) {
          piwik.track(window.location.href)
        }
        currentUrl = window.location.href
      })
    }
  }
}
