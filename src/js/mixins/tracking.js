import PiwikTracker from 'piwik-tracker'

export default function () {
  const piwik = new PiwikTracker(11, 'https://tracking.correctiv.org/piwik.php')
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
