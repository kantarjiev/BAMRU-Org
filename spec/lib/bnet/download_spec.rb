require "spec_helper"
require "#{LIB}/bnet/download"

describe Bnet::Download do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe "Klas" do
    specify { expect(klas).to be_a(Class) }
  end

  describe "Object Methods" do
    specify { expect(klas).to respond_to :execute }
  end
end
