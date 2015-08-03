require 'json'
require_relative "../../base"
require_relative "../../rake/loggers"
require_relative "../../event"
require_relative "../../event/store"

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
        log "Converted GCal JSON to YAML, written to #{@to}"
      end

      private

      def json_events
        return [] unless File.exist?(@from)
        JSON.parse(File.read(@from))
      end

      def events
        prev_opts = nil
        json_events.map do |hsh|
          hsh_start = hsh["start"]
          start = hsh_start["date"] || hsh_start["dateTime"].split('T').first
          opts  = {
            gcal_id:  hsh["id"],
            location: hsh["location"],
            title:    hsh["summary"],
            start:    start
          }

          # Skip events that fall outside of our DateRange
          next if start < DateRange.start_str
          next if start > DateRange.finish_str

          # Handle duplicate records, addition records are hashed with the gcal_id to make them unique
          # When everything is functioning correctly duplicate records shouldn't exist but they creep in
          # during testing
          extend_sig = prev_opts &&
              prev_opts[:title] == opts[:title] &&
              prev_opts[:location] == opts[:location] &&
              prev_opts[:start] == opts[:start] ? " / #{opts[:gcal_id]}" : extend_sig = ""
          prev_opts = opts
          Event.new(opts, extend_sig)
        end.compact
      end
    end
  end
end

