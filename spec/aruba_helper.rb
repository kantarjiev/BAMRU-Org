require_relative './spec_helper'

require 'aruba/rspec'

RSpec.configure do |config|
  config.include ArubaDoubles

  config.before(:each) { Aruba::RSpec.setup    }
  config.after(:each)  { Aruba::RSpec.teardown }
end