require 'csv'
require_relative "../base"
require_relative "../event"
require_relative "../event/store"
require_relative "../rake/loggers"

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
      count = BNET_STORE.all.length
      log "Convert BAMRU.net CSV to YAML: Saved #{count} events to #{@to}"
    end

    private

    def events
      list = []
      prev_event = nil
      CSV.foreach(@from, headers: true) do |csv_event|
        csv_event["finish_date"] = csv_event["begin_date"] if csv_event["finish_date"].blank?

        new_event = Event.new(csv_event, prev_event)
        list << new_event
        prev_event = new_event
      end
      list
    end

  end
end
