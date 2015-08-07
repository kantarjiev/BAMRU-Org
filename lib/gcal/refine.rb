require 'json'
require_relative "../base"
require_relative "../rake/loggers"
require_relative "../event"
require_relative "../event/store"

class CalData
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
        # Sort events to find duplicates
        sorted_events = json_events.sort_by{ |e| e["description"].to_s+e["start"].to_s+e["location"].to_s }
          # use to_s to handle embedded hash and nil

        event = nil
        sorted_events.map do |e|
          start, finish = normalize_gcal_to_bnet_dates(e)
          opts  = {
            gcal_id:  e["id"],
            location: e["location"],
            title:    e["summary"],
            start:    start,
            finish:   finish
          }

          event = Event.new(opts, event) # duplicate if this event matches the previous 
        end
      end

      def normalize_gcal_to_bnet_dates(g_event)
        # Gcal dates are hashes and Gcal end date is exclusive
        # Convert back to Bnet so the hash id is consistent
        g_start = g_event["start"]
        start = g_start["date"] || g_start["dateTime"].split('T').first

        g_finish = g_event["end"]
        if g_finish["date"]
          lcl_date = Time.parse(g_finish["date"]) - 1.day
          finish = lcl_date.strftime("%Y-%m-%d")
        else
          finish = g_finish["dateTime"].split('T').first
        end
        [start, finish]
      end

    end
  end
end

