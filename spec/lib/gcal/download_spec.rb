require "spec_helper"

if File.exist?(CLIENT_SECRET)
  require "#{LIB}/gcal/download"

  describe Gcal::Download do
    let(:klas) { described_class }
    subject    { klas.new        }

    describe "Klas" do
      specify { expect(klas).to be_a(Class) }
    end

    describe "Object Methods" do
      specify { expect(klas).to respond_to :execute }
    end
  end
end
