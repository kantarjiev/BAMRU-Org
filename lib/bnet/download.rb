require "open-uri"
require_relative "../base"
require_relative "../rake/loggers"

class Bnet
  class Download

    extend Rake::Loggers

    class << self
      def execute
        csv_text = download_latest_csv
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

      def has_changed?(new_text)
        new_text != old_text
      end

      def do_not_save_message
        log "Load BAMRU.net data: Events up-to-date -- nothing saved"
      end

      def abort_message
        log "Exiting"
        abort
      end

      def save_new_text(csv_text)
        File.open(BNET_DATA_CSV_FILE, 'w') {|f| f.puts csv_text}
        count = CSV.parse(csv_text, headers: true).length
        log "Load BAMRU.net data: Saved #{count} events to #{BNET_DATA_CSV_FILE}"
      end

      def old_text
        File.exist?(BNET_DATA_CSV_FILE) ? File.read(BNET_DATA_CSV_FILE) : ""
      end
    end
  end
end