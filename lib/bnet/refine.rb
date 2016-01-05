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
      log "Convert BNet CSV to YAML: Saved #{count} events to #{@to}"
    end

    private

    def events
      list = []
      prev_event = nil
      CSV.foreach(@from, headers: true) do |csv_event|
        # normalize date, time, location, description
        # use Time class to correctly account for daylight saving
        csv_event["begin_date"] = csv_event["finish_date"] if csv_event["begin_date"].blank?
        csv_event["begin_time"] = csv_event["finish_time"] if csv_event["begin_time"].blank?
        csv_event["finish_date"] = csv_event["begin_date"] if csv_event["finish_date"].blank?
        csv_event["finish_time"] = csv_event["begin_time"] if csv_event["finish_time"].blank?

        if !csv_event["begin_time"].blank?
          time = Time.parse("#{csv_event['begin_date']}T#{csv_event['begin_time']}".insert(-3,':'))
          csv_event["begin_time"] = time.strftime('%H:%M:%S%z').insert(-3,':')  #RFC3339
        elsif csv_event['kind'] == 'meeting'  # backwards compatible - old style
          time = Time.parse("#{csv_event['begin_date']}T1930".insert(-3,':'))
          csv_event["begin_time"] = time.strftime('%H:%M:%S%z').insert(-3,':')  #RFC3339
        end

        if !csv_event["finish_time"].blank?
          time = Time.parse("#{csv_event['finish_date']}T#{csv_event['finish_time']}".insert(-3,':'))
          csv_event["finish_time"] = time.strftime('%H:%M:%S%z').insert(-3,':')  #RFC3339
        elsif csv_event['kind'] == 'meeting'  # backwards compatible - old style
          time = Time.parse("#{csv_event['finish_date']}T1930".insert(-3,':'))
          csv_event["finish_time"] = time.strftime('%H:%M:%S%z').insert(-3,':')  #RFC3339
        end

        csv_event["location"] = located_at(csv_event)
        csv_event["description"] = leaders_for(csv_event)

        # create normalized event
        new_event = Event.new(csv_event, prev_event)
        list << new_event
        prev_event = new_event
      end

      list
    end

    def located_at(event)
      if event['lat'].blank? or event['lon'].blank?
        event['location']
      elsif event['location'].blank?
        "#{event['lat']}, #{event['lon']}"
      else
        "(#{event['location']}) #{event['lat']}, #{event['lon']}"
      end
    end

    def leaders_for(event)
      if event['leaders'].blank? or event['leaders'] == 'TBA'
        event['description']
      elsif event['description'].blank?
        "Leaders: #{event['leaders']}"
      else
        "#{event['description']}\n\nLeaders: #{event['leaders']}"
      end
    end

  end
end
