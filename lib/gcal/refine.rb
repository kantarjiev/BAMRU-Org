require 'json'
require_relative "../base"
require_relative "../rake/loggers"
require_relative "../event"
require_relative "../event/store"

class Gcal
  class Refine

    extend Rake::Loggers

    def initialize(opts = {})
      @from = opts[:from] || GCAL_DATA_JSON_FILE
      @to   = opts[:to]   || GCAL_DATA_YAML_FILE
      check_format('input' , @from, 'json')
      check_format('output', @to  , 'yaml')
    end

    def execute
      Event::Store.new(@to).destroy_all.create(events)
      count = GCAL_STORE.all.length
      log "Convert GCal JSON to YAML: Saved #{count} events to #{@to}"
    end

    private

    def check_format(file_type, file_name, file_ext)
      msg = "Invalid #{file_type} file (#{file_name})"
      raise msg unless file_name.split('.').last == file_ext
    end

    def json_events
      return [] unless File.exist?(@from)
      JSON.parse(File.read(@from))
    end

    def events
      prev_event    = nil
      sorted_events = json_events.sort_by do |ev|
        # use to_s to handle embedded hash and nil
        ev["description"].to_s + ev["start"].to_s + ev["location"].to_s
      end

      sorted_events.map do |ev|
        e_start = ev["start"]
        start   = e_start["date"] || e_start["dateTime"].split('T').first
        opts    = {
          gcal_id:  ev["id"],
          location: ev["location"],
          title:    ev["summary"],
          start:    start
        }

        prev_event = Event.new(opts, prev_event)
      end
    end
  end
end

