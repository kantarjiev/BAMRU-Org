class DateRange
  class << self
    def start
      (Time.now - 1.month).beginning_of_month
    end

    def finish
      (Time.now + 1.year).end_of_month
    end

    def start_str
      stringified_month start
    end

    def finish_str
      stringified_month finish
    end

    def start_month
      formatted_month start
    end

    def finish_month
      formatted_month finish
    end

    private

    def stringified_month(element)
      element.strftime("%Y-%m-%d")
    end

    def formatted_month(element)
      element.strftime("%b %Y")
    end
  end
end