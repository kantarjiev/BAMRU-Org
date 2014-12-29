require 'json'
require 'tzinfo'
require 'dotenv'
require 'google/api_client'
require_relative "./base"

class GcalClient

  raise "No Gcal Keys" unless File.exists?(ENV_FILE)

  Dotenv.load ENV_FILE

  GAPI     = Google::APIClient
  ISSUER   = ENV["#{MM_ENV.upcase}_ISSUER"]
  CAL_ID   = ENV["#{MM_ENV.upcase}_CAL_ID"]
  KEYFILE  = "./.gcal_keys/bamru_#{MM_ENV}.p12"

  # ----- instance methods -----

  def list_events
    opts = {
      api_method: google_calendar.events.list,
      parameters: {'calendarId' => CAL_ID}
    }
    google_exec(opts)
  end

  def delete_event(google_event_id)
    opts = {
      api_method: google_calendar.events.delete,
      parameters: {'calendarId' => CAL_ID, 'eventId' => google_event_id}
    }
    google_exec(opts)
  end

  def create_event(event_input)
    event_opts = {
      'summary'     => event_input.title,
      'description' => event_input.description,
      'location'    => event_input.location,
      'start'       => start_for(event_input),
      'end'         => end_for(event_input),
    }
    opts = {
      api_method: google_calendar.events.insert,
      parameters: {'calendarId' => CAL_ID},
      body:       JSON.dump(event_opts),
      headers:    {'Content-Type' => 'application/json'}
    }
    google_exec(opts)
  end

  private

  def google_exec(opts)
    sleep 0.33
    google_client.execute(opts)
  end

  # ----- google handles -----

  def google_client
    @authenticated_client ||= create_authenticated_client
  end

  def google_calendar
    @authenticated_calendar ||= create_authenticated_calendar
  end

  # ----- factories -----

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

  # ----- date utilities -----

  def start_for(event)
    if event.kind == 'meeting'
      {"dateTime" => "#{event.start}T19:30:00-#{offset_for(event.start)}:00"}
    else
      {"date" => event.start}
    end
  end

  def end_for(event)
    fin_date = event.finish.blank? ? event.start : event.finish
    if event.kind == 'meeting'
      {"dateTime" => "#{fin_date}T21:30:00-#{offset_for(fin_date)}:00"}
    else
      {"date" => fin_date}
    end
  end

  def offset_for(date)
    @tz ||= TZInfo::Timezone.get('America/Los_Angeles')
    @tz.local_to_utc(Time.parse(date)).to_s.match(/ (\d\d)/)[1]
  end
end