require 'csv'
require_relative "../base"
require_relative "../event"
require_relative "../event/store"
require_relative "../rake/loggers"

class CalData
  class Bnet
    class Refine

      extend Rake::Loggers

      def initialize(opts = {})
        @from = opts[:from] || BNET_DATA_CSV_FILE
        @to   = opts[:to]   || BNET_DATA_YAML_FILE
        raise "Bad input file (#{@from})" unless @from.split('.').last == "csv"
        raise "Bad output file (#{@to})"  unless @to.split('.').last == "yaml"
      end

      def execute
        Event::Store.new(@to).destroy_all.create(events)
        log "Converted BAMRU.net CSV to YAML, written to #{@to}"
      end

      private

      def events
        # csv_events.map do |event|
        list = []
        CSV.foreach(@from, headers: true) do |event|
          list << Event.new(event)
        end
        list
      end
    end
  end
end
