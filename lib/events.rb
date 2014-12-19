require 'active_support'
require 'csv'

class Events

  CSV_FILE = File.expand_path("../data/calendar_downloaded.csv", __dir__)

  class << self
    def range_start
      (Time.now - 1.month).beginning_of_month
    end

    def range_end
      (Time.now + 1.year).end_of_month
    end

    def range_start_month
      formatted_month range_start
    end

    def range_end_month
      formatted_month range_end
    end

    private

    def formatted_month(element)
      element.strftime("%b %Y")
    end
  end

  attr_reader :events

  def initialize
    puts "CSV FILE IS #{CSV_FILE}"
    @events = []
    idx = 0
    CSV.foreach(CSV_FILE, headers: true) do |row|
      idx += 1
      row["id"] = idx
      @events << row
    end
  end

  def meetings
    match("kind", "meeting")
  end

  def trainings
    match("kind", "training")
  end

  def others
    match("kind", "community")
  end

  private

  def match(key, value)
    @events.select {|event| event[key] == value}
  end
end