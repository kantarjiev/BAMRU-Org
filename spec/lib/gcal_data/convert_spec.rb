require "spec_helper"
require "#{LIB}/gcal_data/convert"

describe GcalData::Convert do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe "Klas" do
    specify { expect(klas).to be_a(Class) }
  end

  describe "Instance Methods" do
    it { should respond_to :execute }
  end

  describe "_json_events" do
    it "returns an array" do
      expect(subject.send(:json_events)).to be_an(Array)
    end
  end

  describe "_events" do
    it "returns an array" do
      expect(subject.send(:events)).to be_an(Array)
    end
  end
end