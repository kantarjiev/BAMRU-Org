require 'active_support'
require 'csv'

module Event::WebUI

  CSV_FILE = File.expand_path("../data/calendar_downloaded.csv", __dir__)

  # ----- class methods -----

  class << self
    def range_start
      (Time.now - 1.month).beginning_of_month
    end

    def range_end
      (Time.now + 1.year).end_of_month
    end

    def range_start_str
      stringified_month range_start
    end

    def range_end_str
      stringified_month range_end
    end

    def range_start_month
      formatted_month range_start
    end

    def range_end_month
      formatted_month range_end
    end

    private

    def stringified_month(element)
      element.strftime("%Y-%m-%d")
    end

    def formatted_month(element)
      element.strftime("%b %Y")
    end
  end

  # ----- instance methods -----

  attr_reader :events

  def initialize
    @events = []
    idx = 0
    CSV.foreach(CSV_FILE, headers: true) do |row|
      idx += 1
      row["id"] = idx
      @events << row
    end
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
    @events.select do |event|
      start = event["start"]
      next if event[key] != value
      next if self.class.range_start_str > start
      next if self.class.range_end_str   < start
      event["prior"] = prior
      prior = event
      true
    end
  end
end