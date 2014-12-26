require 'json'
require 'pry'
require 'google/api_client'
require_relative '../gcal_data'
require_relative '../rake/loggers'

class GcalData
  class Download

    extend Rake::Loggers

    ISSUER   = '676559655687-3cgu2akc11avh0v2m4gcpq75eq6ch5u9@developer.gserviceaccount.com'
    GAPI     = Google::APIClient
    CID      = "bamru.calendar@gmail.com"
    KEYFILE  = './keys/bamru.p12'

    class << self
      def execute
        json_text = download_latest_json
        if has_changed?(json_text)
          save_new_text(json_text)
        else
          do_not_save_text
        end
      end

      private

      def download_latest_json
        opts   = {application_name: "test", application_version: "0.0.1"}
        client = GAPI.new(opts)
        cal    = client.discovered_api('calendar', 'v3')
        key    = GAPI::KeyUtils.load_from_pkcs12(KEYFILE, 'notasecret')
        client.authorization = Signet::OAuth2::Client.new(
          token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
          audience:    'https://accounts.google.com/o/oauth2/token',
          scope:       'https://www.googleapis.com/auth/calendar',
          issuer:      ISSUER,
          signing_key: key
        )
        client.authorization.fetch_access_token!
        event_list = client.execute(method_opts(cal.events.list))
        event_hash = JSON.parse(event_list.body.scrub)
        JSON.pretty_generate(event_hash["items"]) + "\n"
      end

      def has_changed?(new_text)
        new_text != old_text
      end

      def do_not_save_text
        log "Gcal Events has not changed - nothing saved"
      end

      def save_new_text(json_text)
        File.open(GCAL_DATA_JSON_FILE, 'w') {|f| f.puts json_text}
        msg = `wc -l #{GCAL_DATA_JSON_FILE}`.strip.chomp.split(' ')
        log "Gcal event data has been downloaded"
        log "#{msg[0]} records saved to #{msg[1]}"
      end

      def old_text
        File.exist?(GCAL_DATA_JSON_FILE) ? File.read(GCAL_DATA_JSON_FILE) : ""
      end

      def method_opts(method)
        {
          api_method: method,
          parameters: {'calendarId' => CID}
        }
      end
    end
  end
end
