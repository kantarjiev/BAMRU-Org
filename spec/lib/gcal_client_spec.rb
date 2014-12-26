require "spec_helper"
require "#{LIB}/gcal_client"

describe GcalClient do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe "Object" do
    specify { expect(klas).to be_a(Class) }
  end

  describe "Instance Methods" do
    it { should respond_to :list_events                }
  end
end