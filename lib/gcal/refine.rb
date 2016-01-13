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
        begin_date, begin_time, finish_date, finish_time = normalize_gcal_to_canonical_dates(e)
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

    # canonical form: date time YY-MM-DD HH:MM:SS-TZ
    def normalize_gcal_to_canonical_dates(g_event)
      # GCal dates are date, dateTime hashes. The GCal end date is exclusive
      # Convert back to BNet format so the hash ids are consistent

      begin_event = g_event["start"]
      finish_event = g_event["end"]

      if begin_event["date"]
        begin_date, begin_time = [begin_event["date"], ""]
      else
        # break properly format datetime into date and time
        time = begin_event["dateTime"].split('T')
        begin_date, begin_time = time
      end
      
      if finish_event["date"]
        # account for GCal exclusive date format
        time = Time.parse(finish_event["date"]) - 1.day
        finish_date, finish_time = [time.strftime("%Y-%m-%d"), ""]
      else
        # break properly format datetime into date and time
        time = finish_event["dateTime"].split('T')
        finish_date, finish_time = time
      end

      [begin_date, begin_time, finish_date, finish_time]
    end

  end
end

