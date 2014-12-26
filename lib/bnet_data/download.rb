require "open-uri"
require_relative "../bnet_data"
require_relative "../rake/loggers"

class BnetData
  class Download

    extend Rake::Loggers

    class << self
      def execute
        csv_text = download_latest_csv
        if has_changed?(csv_text)
          save_new_text(csv_text)
        else
          do_not_save_text
        end
      end

      private

      def download_latest_csv
        raw_text = open(BNET_DATA_SRC_URL).read
        raw_text.delete("^\u{0000}-\u{007F}")     # remove non-ascii characters
      end

      def has_changed?(new_text)
        new_text != old_text
      end

      def do_not_save_text
        log "CSV Text has not changed - nothing saved"
      end

      def save_new_text(csv_text)
        File.open(BNET_DATA_CSV_FILE, 'w') {|f| f.puts csv_text}
        msg = `wc -l #{BNET_DATA_CSV_FILE}`.strip.chomp.split(' ')
        log "BAMRU.net event data has been downloaded"
        log "#{msg[0]} records saved to #{msg[1]}"
      end

      def old_text
        File.exist?(BNET_DATA_CSV_FILE) ? File.read(BNET_DATA_CSV_FILE) : ""
      end
    end
  end
end

