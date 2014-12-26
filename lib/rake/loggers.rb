require 'colored'

module Rake
  module Loggers
    LOGLEN = 75

    def log(text)
      puts "--- #{text} ---".ljust(LOGLEN,'-').yellow
    end

    def info(text)
      puts " #{text} ".center(LOGLEN, '-').yellow
    end
  end
end