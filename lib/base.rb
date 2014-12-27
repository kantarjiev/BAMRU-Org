require_relative './event/store'

# ----- bnet data files -----

BNET_DATA_SRC_URL   ||= "http://bamru.net/public/calendar.csv"
BNET_DATA_CSV_FILE  ||= "events/bnet_data.csv"
BNET_DATA_YAML_FILE ||= "events/bnet_data.yaml"

# ----- gcal data files -----

GCAL_DATA_JSON_FILE ||= "events/gcal_data.json"
GCAL_DATA_YAML_FILE ||= "events/gcal_data.yaml"

# ----- store objects -----

BNET_STORE ||= Event::Store.new(BNET_DATA_YAML_FILE)
GCAL_STORE ||= Event::Store.new(GCAL_DATA_YAML_FILE)
