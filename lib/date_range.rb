class DateRange
  class << self
    def start
      Time.now.beginning_of_day
    end

    def finish
      (Time.now + 1.year).end_of_month
    end

    def cal_start
      (Time.now - 1.year).beginning_of_year
    end

    def cal_finish
      (Time.now + 1.year).end_of_month
    end

    def start_str
      stringified_month start
    end

    def finish_str
      stringified_month finish
    end

    def cal_start_str
      stringified_month cal_start
    end

    def cal_finish_str
      stringified_month cal_finish
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
