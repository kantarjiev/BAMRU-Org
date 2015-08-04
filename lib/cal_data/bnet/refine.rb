require 'csv'
require_relative "../../base"
require_relative "../../event"
require_relative "../../event/store"
require_relative "../../rake/loggers"

class CalData
  class Bnet
    class Refine

      extend Rake::Loggers

      def initialize(opts = {})
        @from = opts[:from] || BNET_DATA_CSV_FILE
        @to   = opts[:to]   || BNET_DATA_YAML_FILE
        raise "Invalid input file (#{@from})" unless @from.split('.').last == "csv"
        raise "Invalid output file (#{@to})"  unless @to.split('.').last == "yaml"
      end

      def execute
        Event::Store.new(@to).destroy_all.create(events)
        log "Converted BAMRU.net CSV to YAML, written to #{@to}"
      end

      private

      def csv_events
        return [] unless File.exist?(@from)
        csv_events = []
        CSV.foreach(@from, headers: true) do |row|
          next if row["start"] < DateRange.start_str
          next if row["start"] > DateRange.finish_str
          csv_events << row
        end
        csv_events
      end

      def events
        csv_events.map do |event|
          Event.new(event)
        end
      end
    end
  end
end
