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
      # Sort events to find duplicates
      sorted_events = json_events.sort_by do |e|
        # use to_s to handle data that contains embedded hash and nil
        e["title"].to_s + e["begin_date"].to_s + e["begin_time"].to_s +
          e["finish_date"].to_s + e["finish_time"].to_s +
          e["gcal_location"].to_s + e["gcal_description"].to_s
      end

      prev_event = nil
      sorted_events.map do |e|
        begin_date, begin_time, finish_date, finish_time = normalize_gcal_to_bnet_dates(e)
        opts  = {
          title:       e["summary"],
          begin_date:  begin_date,
          begin_time:  begin_time,
          finish_date: finish_date,
          finish_time: finish_time,
          gcal_id:          e["id"],
          gcal_location:    e["location"],
          gcal_description: e["description"]
        }

        event = Event.new(opts, prev_event)
        prev_event = event
      end
    end

    # date/time/zone YY-MM-DD HH:MM Z
    def normalize_gcal_to_bnet_dates(g_event)
      # GCal dates are date, dateTime hashes and GCal end date is exclusive
      # Convert back to BNet format so the hash id is consistent
      begin_event = g_event["start"]
      if begin_event["date"]
        begin_date = begin_event["date"]
        begin_time = ""
      else
        time = Time.parse(begin_event["dateTime"])
        begin_date = time.strftime('%Y-%m-%d')
        begin_time = time.strftime('%H:%M:%S%z').insert(-3,':')  #RFC3339
      end
      
      finish_event = g_event["end"]
      if finish_event["date"]
        time = Time.parse(finish_event["date"]) - 1.day
        finish_date = time.strftime("%Y-%m-%d")
        finish_time = ""
      else
        time = Time.parse(finish_event["dateTime"])
        finish_date = time.strftime('%Y-%m-%d')
        finish_time = time.strftime('%H:%M:%S%z').insert(-3,':')  #RFC3339
      end
      [begin_date, begin_time, finish_date, finish_time]
    end

  end
end

