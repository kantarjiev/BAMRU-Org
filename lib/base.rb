require_relative './bnet_data'
require_relative './gcal_data'
require_relative './event/store'

BNET_STORE ||= Event::Store.new(BNET_DATA_YAML_FILE)
GCAL_STORE ||= Event::Store.new(GCAL_DATA_YAML_FILE)

