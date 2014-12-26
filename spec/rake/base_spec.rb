require 'aruba_helper'

describe "Rakefile" do
  it "runs and shows rake options" do
    expect { `bundle exec rake -T` }.to have_exit_status(0)
  end
end