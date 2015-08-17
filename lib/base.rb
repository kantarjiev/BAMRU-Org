# ----- core environment -----

# either 'test' or 'production'
# for example - use: MM_ENV=test rake -T

# additional test flags: debug, verbose, readonly
# for example - use: MM_ENV=test BAMRU_FLAGS=debug:verbose rake -T

BASE_DIR ||= File.dirname(File.realpath(__FILE__))
MM_ENV   ||= ENV["MM_ENV"] || "test"
MM_ROOT  ||= File.expand_path("../", BASE_DIR)

def valid_env?
  %w(test production).include?(MM_ENV)
end

raise "Environment setting must be 'production' or 'test'" unless valid_env?

# ----- test flags -----

def default_flags
  MM_ENV == "test" ? "debug:verbose" : ""
end

BASE_FLAGS   ||= ENV["BAMRU_FLAGS"] || default_flags
TEST_FLAGS   ||= BASE_FLAGS.strip.chomp.split(':')
DEBUG        ||= TEST_FLAGS.include? "debug"
READONLY     ||= TEST_FLAGS.include? "readonly"
VERBOSE      ||= BASE_FLAGS.match(/verbose/)
VERBOSE_PLUS ||= BASE_FLAGS.match(/verbose\+/)

# ----- gcal keys / environment -----

APPLICATION_NAME ||= "BAMRU Google Calendar Publish"
GCAL_KEYS        ||= File.expand_path("~/.gcal_keys")

CLIENT_SECRET ||= "#{GCAL_KEYS}/client_secret.json"
CREDENTIAL    ||= "#{GCAL_KEYS}/#{MM_ENV}_calendar_credential.json"
SCOPE         ||= "https://www.googleapis.com/auth/calendar" + (READONLY ? ".readonly" : "")

# ----- bnet data files -----

BNET_DATA_SRC_URL   ||= "http://bamru.net/public/calendar.csv"
BNET_DATA_CSV_FILE  ||= "cal_data/bnet.csv"
BNET_DATA_YAML_FILE ||= "cal_data/bnet.yaml"

# ----- gcal data files -----

GCAL_DATA_JSON_FILE ||= "cal_data/gcal_#{MM_ENV}.json"
GCAL_DATA_YAML_FILE ||= "cal_data/gcal_#{MM_ENV}.yaml"

# ----- log files -----

GCAL_SYNC_LOG ||= "cal_data/GcalSync.log"   # Sync Log
CRON_LOG      ||= "/tmp/bamru_org.log"

# ----- store objects -----

require_relative './event/store'

BNET_STORE ||= Event::Store.new(BNET_DATA_YAML_FILE)
GCAL_STORE ||= Event::Store.new(GCAL_DATA_YAML_FILE)

require 'pry' if DEBUG
