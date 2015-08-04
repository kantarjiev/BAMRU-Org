require "open-uri"
require_relative "../../base"
require_relative "../../rake/loggers"

class CalData
  class Bnet
    class Download

      extend Rake::Loggers

      class << self
        def execute
          csv_text = event_filter(download_latest_csv)
          if has_changed?(csv_text)
            save_new_text(csv_text)
          else
            do_not_save_message
            abort_message           if MM_ENV == 'production'
          end
        end

        private

        def download_latest_csv
          raw_text = open(BNET_DATA_SRC_URL).read
          raw_text.delete("^\u{0000}-\u{007F}")   # remove non-ascii characters
        end

        def event_filter(text)
          output = [text.lines.first.chomp]
          CSV.parse(text, headers: true) do |row|
            next if row["start"] < DateRange.start_str    # filter by date-range
            next if row["start"] > DateRange.finish_str   # filter by date-range
            next if row["kind"] == "operation"            # filter by event kind
            output << row.to_s.chomp
          end
          output.join("\n")
        end

        def has_changed?(new_text)
          (new_text + "\n") != old_text
        end

        def do_not_save_message
          log "CSV Text has not changed - nothing saved"
        end

        def abort_message
          log "Exiting"
          abort
        end

        def save_new_text(csv_text)
          File.open(BNET_DATA_CSV_FILE, 'w') {|f| f.puts csv_text}
          count = csv_text.lines.count - 2
          # msg = `wc -l #{BNET_DATA_CSV_FILE}`.strip.chomp.split(' ')
          log "BAMRU.net event data has been downloaded"
          log "#{count} records saved to #{BNET_DATA_CSV_FILE}"
        end

        def old_text
          File.exist?(BNET_DATA_CSV_FILE) ? File.read(BNET_DATA_CSV_FILE) : ""
        end
      end
    end
  end
end

