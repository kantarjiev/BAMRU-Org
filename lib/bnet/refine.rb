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
        # normalize date and time
        # canonical form: date time YY-MM-DD HH:MM:SS-TZ
        # use Time class to correctly account for daylight savings
        csv_event["finish_date"] = csv_event["begin_date"] if csv_event["finish_date"].blank?
        csv_event["begin_time"] = csv_event["finish_time"] if csv_event["begin_time"].blank?
        csv_event["finish_time"] = csv_event["begin_time"] if csv_event["finish_time"].blank?

        if ! csv_event["begin_time"].blank?
          time = Time.parse("#{csv_event['begin_date']}T#{csv_event['begin_time']}".insert(-3,':'))
          csv_event["begin_time"] = time.strftime('%H:%M:%S%z').insert(-3,':')  #insert ':'for RFC3339
        elsif csv_event['kind'] == 'meeting'  # backwards compatible - old style
          time = Time.parse("#{csv_event['begin_date']}T1930".insert(-3,':'))
          csv_event["begin_time"] = time.strftime('%H:%M:%S%z').insert(-3,':')
        end

        if ! csv_event["finish_time"].blank?
          time = Time.parse("#{csv_event['finish_date']}T#{csv_event['finish_time']}".insert(-3,':'))
          csv_event["finish_time"] = time.strftime('%H:%M:%S%z').insert(-3,':')  #insert ':'for RFC3339
        elsif csv_event['kind'] == 'meeting'  # backwards compatible - old style
          time = Time.parse("#{csv_event['finish_date']}T2130".insert(-3,':'))
          csv_event["finish_time"] = time.strftime('%H:%M:%S%z').insert(-3,':')
        end

        # normalize gcal_data
        csv_event['gcal_location'], csv_event['gcal_description'] = normalize_gcal_data(csv_event)

        # create normalized event
        new_event = Event.new(csv_event, prev_event)
        list << new_event
        prev_event = new_event
      end

      list
    end

    private

    def normalize_gcal_data(csv_event)

      # only set gcal_location when there is a lat/lon
      loc = latlon(csv_event)

      # add location and leader information to gcal_description
      desc = leaders(csv_event) + location(csv_event) + description(csv_event)

      [loc, desc.strip]
    end

    def latlon(csv_event)
      lat = csv_event['lat']
      lon = csv_event['lon']
      present = ! (lat.blank? or lon.blank? or [lat, lon].include?('TBA'))

      present ? "#{csv_event['lat']}, #{csv_event['lon']}" : ''
    end

    def leaders(csv_event)
      present = csv_event['leaders'].present? && csv_event['leaders'] != 'TBA'
      s =  csv_event['leaders'].count(',') > 0 ? 's' : '' if present

      present ? "Leader#{s}: #{csv_event['leaders']}\n" : ''
    end

    def location(csv_event)
      present = csv_event['location'].present? && csv_event['location'] != 'TBA'

      present ? "Location: #{csv_event['location']}\n" : ''
    end

    def description(csv_event)
      present = csv_event['description'].present?

      present ? "\n#{csv_event['description']}" : ''
    end

  end
end
