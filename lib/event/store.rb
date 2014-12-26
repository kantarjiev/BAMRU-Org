require "yaml/store"
require_relative "../event"
require_relative "../date_range"

class Event::Store

  attr_accessor :data_file, :store

  def initialize(data_file)
    @data_file = data_file
    @store     = YAML::Store.new @data_file
  end

  def all
    @cache ||= @store.transaction(true) do
      @store.fetch(:data, {})
    end
  end

  def create(input_value)
    @cache = nil; keys = []
    val_arr = Array(input_value)
    @store.transaction do
      @store[:data] ||= {}
      keys = val_arr.map do |val|
        key = val.hash.to_s.reverse[0..10].reverse
        @store[:data][key] = val
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
      @store[:data] = {}
    end
    self
  end

  def meetings
    @meetings ||= match("kind", "meeting")
  end

  def trainings
    @trainings ||= match("kind", "training")
  end

  def others
    @others ||= match("kind", "community")
  end

  private

  def match(key, value)
    prior = nil
    all.select do |_hsh_key, event|
      start_value = event.start
      next false if event.send(key.to_sym) != value
      next false if DateRange.start_str  > start_value
      next false if DateRange.finish_str < start_value
      event.prior = prior
      prior = event
      true
    end
  end

end