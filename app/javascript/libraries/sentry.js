import * as Sentry from "@sentry/browser"
import { Integrations } from "@sentry/tracing"

$(document).on("turbolinks:load", () => {
  if (!window.Sentry) {
    window.Sentry = Sentry
    const config = {
      dsn: window.sentryDsn,
      integrations: [
        new Integrations.BrowserTracing(),
      ],
      tracesSampleRate: 1.0,
    }
    Sentry.init(config)
    const NOT_LOGGED = "not logged"
    // https://docs.sentry.io/platforms/javascript/enriching-events/context/
    Sentry.setContext("custom_context", {
      current_user: window.current_user || NOT_LOGGED,
      current_company: window.current_company || NOT_LOGGED
    })
  }
})
