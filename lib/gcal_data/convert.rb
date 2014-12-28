require 'json'
require_relative "../base"
require_relative "../rake/loggers"
require_relative "../event"
require_relative "../event/store"

class GcalData
  class Convert

    extend Rake::Loggers

    def initialize(from: GCAL_DATA_JSON_FILE, to: GCAL_DATA_YAML_FILE)
      raise "Invalid input file (#{from})" unless from.split('.').last == "json"
      raise "Invalid output file (#{to})"  unless to.split('.').last == "yaml"
      @from = from
      @to   = to
    end

    def execute
      Event::Store.new(@to).destroy_all.create(events)
      log "Converted GCAL records written to #{@to}"
    end

    private

    def json_events
      return [] unless File.exist?(@from)
      JSON.parse(File.read(@from))
    end

    def events
      json_events.map do |hsh|
        hsh_start = hsh["start"]
        start = hsh_start["date"] || hsh_start["dateTime"].split('T').first
        opts  = {
          gcal_id:  hsh["id"],
          location: hsh["location"],
          title:    hsh["summary"],
          start:    start
        }
        Event.new(opts)
      end
    end
  end
end

