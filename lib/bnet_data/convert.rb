require 'csv'
require_relative "../bnet_data"
require_relative "../rake/loggers"
require_relative "../event"
require_relative "../event/store"

class BnetData
  class Convert

    extend Rake::Loggers

    def initialize(from: BNET_DATA_CSV_FILE, to: BNET_DATA_YAML_FILE)
      raise "Invalid input file (#{from})" unless from.split('.').last == "csv"
      raise "Invalid output file (#{to})"  unless to.split('.').last == "yaml"
      @from = from
      @to   = to
    end

    def execute
      Event::Store.new(@to).destroy_all.create(events)
      log "Converted BNET records written to #{@to}"
    end

    private

    def csv_events
      return [] unless File.exist?(@from)
      csv_events = []
      CSV.foreach(@from, headers: true) do |row|
        csv_events << row
      end
      csv_events
    end

    def events
      csv_events.map { |event| Event.new(event) }
    end
  end
end
