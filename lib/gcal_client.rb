require 'google/api_client'

class GcalClient

  ISSUER   = '676559655687-3cgu2akc11avh0v2m4gcpq75eq6ch5u9@developer.gserviceaccount.com'
  GAPI     = Google::APIClient
  CID      = "bamru.calendar@gmail.com"
  KEYFILE  = './gcal_keys/bamru.p12'

  def list_events
    google_client.execute(method_opts(google_calendar.events.list))
  end

  private

  def google_client
    @authenticated_client ||= create_authenticated_client
  end

  def google_calendar
    @authenticated_calendar ||= create_authenticated_calendar
  end

  def method_opts(method)
    {
      api_method: method,
      parameters: {'calendarId' => CID}
    }
  end

  def create_authenticated_client
    opts   = {application_name: "test", application_version: "0.0.1"}
    client = GAPI.new(opts)
    key    = GAPI::KeyUtils.load_from_pkcs12(KEYFILE, 'notasecret')
    client.authorization = Signet::OAuth2::Client.new(
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      audience:    'https://accounts.google.com/o/oauth2/token',
      scope:       'https://www.googleapis.com/auth/calendar',
      issuer:      ISSUER,
      signing_key: key
    )
    client.authorization.fetch_access_token!
    client
  end

  def create_authenticated_calendar
    google_client.discovered_api('calendar', 'v3')
  end
end