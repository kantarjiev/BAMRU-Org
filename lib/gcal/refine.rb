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
      raise "Invalid input file (#{@from})" unless @from.split('.').last == "json"
      raise "Invalid output file (#{@to})"  unless @to.split('.').last == "yaml"
    end

    def execute
      Event::Store.new(@to).destroy_all.create(events)
      count = GCAL_STORE.all.length
      log "Convert GCal JSON to YAML: Saved #{count} events to #{@to}"
    end

    private

    def json_events
      return [] unless File.exist?(@from)
      JSON.parse(File.read(@from))
    end

    def events
      prev_event = nil
      sorted_events = json_events.sort_by{ |e| e["description"].to_s+e["start"].to_s+e["location"].to_s }
      # use to_s to handle embedded hash and nil

      sorted_events.map do |e|
        e_start = e["start"]
        start = e_start["date"] || e_start["dateTime"].split('T').first
        opts  = {
          gcal_id:  e["id"],
          location: e["location"],
          title:    e["summary"],
          start:    start
        }

        prev_event = Event.new(opts, prev_event)
      end
    end
  end
end

