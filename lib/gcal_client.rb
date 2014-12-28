require 'dotenv'
require 'google/api_client'
require_relative "./base"

class GcalClient

  env_file = File.expand_path("../gcal_keys/env", __dir__)
  raise "No Gcal Keys" unless File.exists?(env_file)

  Dotenv.load env_file

  GAPI     = Google::APIClient
  ISSUER   = ENV["#{MM_ENV.upcase}_ISSUER"]
  CAL_ID   = ENV["#{MM_ENV.upcase}_CAL_ID"]
  KEYFILE  = "./gcal_keys/bamru_#{MM_ENV}.p12"

  def list_events
    opts = {
      api_method: google_calendar.events.list,
      parameters: {'calendarId' => CAL_ID}
    }
    google_client.execute(opts)
    sleep 0.33
  end

  def delete_event(google_event_id)
    opts = {
      api_method: google_calendar.events.delete,
      parameters: {'calenderId' => CAL_ID, 'eventId' => google_event_id}
    }
    google_client.execute(opts)
    sleep 0.33
  end

  def create_event(event)
    event = {
      'summary'     => event.title,
      'description' => event.description,
      'start'       => start_for(event),
      'finish'      => finish_for(event),
    }
    opts = {
      api_method: google_calendar.events.insert,
      parameters: {'calendarId' => CAL_ID},
      body:       [event.to_json]
    }
    google_client.execute(opts)
    sleep 0.33
  end

  private

  # ----- google handles -----

  def google_client
    @authenticated_client ||= create_authenticated_client
  end

  def google_calendar
    @authenticated_calendar ||= create_authenticated_calendar
  end

  # ----- calendar factories -----

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

  # ----- event creation -----


end