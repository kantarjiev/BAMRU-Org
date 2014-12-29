require 'json'
require 'pry'
require_relative '../../base'
require_relative '../../rake/loggers'
require_relative '../../gcal_client'

class Data
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
          client     = GcalClient.new
          event_list = client.list_events
          event_hash = JSON.parse(event_list.body.scrub)
          error_msg  = "ERROR: failed to download Google data\n#{event_hash}"
          raise error_msg if event_hash["items"].nil?
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
      end
    end
  end
end
