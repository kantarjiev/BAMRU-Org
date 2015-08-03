# ----- core environment -----

# either 'test' or 'production'
# for example - use: MM_ENV=test rake -T

# additional test flags: debug, verbose, readonly
# for example - use: MM_ENV=test BAMRU_FLAGS=debug:verbose rake -T

BASE_DIR ||= File.dirname(File.realpath(__FILE__))

MM_ENV   ||= ENV["MM_ENV"] || "test"
raise "Environment setting must be 'production' or 'test'" unless MM_ENV == "production" || MM_ENV == "test"

MM_ROOT  ||= File.expand_path("../", BASE_DIR)

# ----- test flags -----

TEST_FLAGS ||= (ENV["BAMRU_FLAGS"].strip.chomp.split(':') if ENV["BAMRU_FLAGS"] ) || "debug:verbose"
DEBUG ||= TEST_FLAGS.include? "debug"
READONLY  ||= TEST_FLAGS.include? "readonly"
VERBOSE  ||= TEST_FLAGS.include? "verbose"

# ----- gcal keys / environment -----

APPLICATION_NAME ||= "BAMRU Google Calendar Publish"
File.expand_path("../.gcal_keys/env", BASE_DIR)

CLIENT_SECRET ||= File.expand_path("../.gcal_keys/#{MM_ENV}_secret.json", BASE_DIR)
CREDENTIAL ||= File.expand_path("../.gcal_keys/#{MM_ENV}_calendar_credential.json", BASE_DIR)
SCOPE ||= "https://www.googleapis.com/auth/calendar" + (READONLY ? ".readonly" : "")

# ----- bnet data files -----

BNET_DATA_SRC_URL   ||= "http://bamru.net/public/calendar.csv"
BNET_DATA_CSV_FILE  ||= "cal_data/bnet.csv"
BNET_DATA_YAML_FILE ||= "cal_data/bnet.yaml"

# ----- gcal data files -----

GCAL_DATA_JSON_FILE ||= "cal_data/gcal_#{MM_ENV}.json"
GCAL_DATA_YAML_FILE ||= "cal_data/gcal_#{MM_ENV}.yaml"

# ----- store objects -----

require_relative './event/store'

BNET_STORE ||= Event::Store.new(BNET_DATA_YAML_FILE)
GCAL_STORE ||= Event::Store.new(GCAL_DATA_YAML_FILE)

require 'pry' if DEBUG
