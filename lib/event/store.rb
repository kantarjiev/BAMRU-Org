require "yaml/store"
require_relative "../event"
require_relative "../date_range"

class Event::Store

  attr_accessor :data_file, :store

  def initialize(data_file)
    @data_file = data_file
    @data_dir  = File.dirname(File.expand_path(data_file))
    system "mkdir -p #{@data_dir}"
    @store     = YAML::Store.new @data_file
  end

  def all
    @cache ||= @store.transaction(true) do
      @store.fetch(:cal_data, {})
    end
  end

  def create(input_value)
    @cache = nil; keys = []
    val_arr = Array(input_value)
    @store.transaction do
      @store[:cal_data] ||= {}
      keys = val_arr.map do |val|
        key = val.hash.to_s
        @store[:cal_data][key] = val
        key
      end
    end
    keys
  end

  def find(key)
    all[key]
  end

  def destroy_all
    @cache = nil
    @store.transaction do
      @store[:cal_data] = {}
    end
    self
  end

  def calendar_events
    @calendar_events ||= match_cal("kind", ["meeting", "training", "community"])
  end

  def meetings
    @meetings ||= match_web("kind", ["meeting"])
  end

  def trainings
    @trainings ||= match_web("kind", ["training"])
  end

  def others
    @others ||= match_web("kind", ["community"])
  end

  def starts_on(date)
    match_web("start", date)
  end

  private

  def match_web(key, value)
    match_with_limits(key, value, DateRange.start_str, DateRange.finish_str)
  end    

  def match_cal(key, value)
    match_with_limits(key, value, DateRange.cal_start_str, DateRange.cal_finish_str)
  end    

  def match_with_limits(key, values, start, finish)
    prior = nil
    all.select do |_hsh_key, event|
      start_value = event.start
      next false if not values.include?(event.send(key.to_sym))
      next false if start  > start_value
      next false if finish < start_value
      event.prior = prior
      prior = event
      true
    end
  end

end
