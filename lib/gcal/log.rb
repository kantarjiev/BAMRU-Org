class Gcal
  module Log

    private

    def log_header
      width     = 70
      timestamp = Time.now.strftime("%y-%m-%d %H:%M")
      log_msg   = " GCAL SYNC - #{timestamp} - MM_ENV=#{MM_ENV} "
      div_msg   = log_msg.center(width, '-')
      divider   = "-" * width
      write_to_log_file [divider, div_msg].join("\n")
    end

    def log_create(event)
      msg = "CREATED: #{event.title} [#{event.start}]"
      write_to_console(msg)
      write_to_log_file(msg)
    end

    def log_delete(event, alt_text = "")
      msg = "DELETED: #{event.title} [#{event.start}] #{alt_text}"
      write_to_console(msg)
      write_to_log_file(msg)
    end

    def log_error(event, error = "")
      msg = "DELETE ERROR: #{event.title} [#{event.start}] #{error}"
      write_to_console(msg)
      write_to_log_file(msg)
    end

    def write_to_console(msg)
      puts msg if VERBOSE
    end

    def write_to_log_file(msg)
      return unless MM_ENV == "production"
      File.open(GCAL_SYNC_LOG, 'a') { |f| f.puts(msg) }
    end
  end
end