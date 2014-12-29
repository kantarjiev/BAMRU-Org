require_relative './event/store'

# ----- core environment -----

MM_ENV  ||= "production"  # can be either 'test' or 'production'

MM_ROOT ||= File.expand_path("../", __dir__)

# ----- bnet data files -----

BNET_DATA_SRC_URL   ||= "http://bamru.net/public/calendar.csv"
BNET_DATA_CSV_FILE  ||= "event_data/bnet_data.csv"
BNET_DATA_YAML_FILE ||= "event_data/bnet_data.yaml"

# ----- gcal data files -----

GCAL_DATA_JSON_FILE ||= "event_data/gcal_data_#{MM_ENV}.json"
GCAL_DATA_YAML_FILE ||= "event_data/gcal_data_#{MM_ENV}.yaml"

# ----- store objects -----

BNET_STORE ||= Event::Store.new(BNET_DATA_YAML_FILE)
GCAL_STORE ||= Event::Store.new(GCAL_DATA_YAML_FILE)
