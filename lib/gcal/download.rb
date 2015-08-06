require 'json'
require_relative '../base'
require_relative '../rake/loggers'
require_relative '../gcal/client'

class CalData
  class Gcal
    class Download

      extend Rake::Loggers

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
          client     = ::Gcal::Client.new
          event_list = client.list_events
          JSON.pretty_generate(event_list) + "\n"
        end

        def has_changed?(new_text)
          new_text != old_text
        end

        def do_not_save_text
          log "Load Gcal data: Events up-to-date -- nothing saved"
        end

        def save_new_text(json_text)
          File.open(GCAL_DATA_JSON_FILE, 'w') {|f| f.puts json_text}
          count = JSON.parse(json_text).length
          log "Load Gcal data: Saved #{count} events to #{GCAL_DATA_JSON_FILE}"
        end

        def old_text
          File.exist?(GCAL_DATA_JSON_FILE) ? File.read(GCAL_DATA_JSON_FILE) : ""
        end
      end
    end
  end
end
