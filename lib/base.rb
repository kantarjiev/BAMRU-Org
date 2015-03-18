require_relative './event/store'

# ----- core environment -----

# either 'test' or 'production'
# for example - use: MM_ENV=test rake -T
MM_ENV  ||= ENV["MM_ENV"] || "test"

MM_ROOT ||= File.expand_path("../", __dir__)

# ----- gcal keys / environment -----

ENV_FILE ||= File.expand_path("../.gcal_keys/env", __dir__)

# ----- bnet data files -----

BNET_DATA_SRC_URL   ||= "http://bamru.net/public/calendar.csv"
BNET_DATA_CSV_FILE  ||= "cal_data/bnet.csv"
BNET_DATA_YAML_FILE ||= "cal_data/bnet.yaml"

# ----- gcal data files -----

GCAL_DATA_JSON_FILE ||= "cal_data/gcal_#{MM_ENV}.json"
GCAL_DATA_YAML_FILE ||= "cal_data/gcal_#{MM_ENV}.yaml"

# ----- store objects -----

BNET_STORE ||= Event::Store.new(BNET_DATA_YAML_FILE)
GCAL_STORE ||= Event::Store.new(GCAL_DATA_YAML_FILE)
