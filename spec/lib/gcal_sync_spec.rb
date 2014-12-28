require "spec_helper"
require "#{LIB}/gcal_sync"

describe GcalSync do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe "Object" do
    specify { expect(klas).to be_a(Class) }
  end

  describe "Instance Methods" do
    it { should respond_to :pending_delete           }
    it { should respond_to :pending_create           }
    it { should respond_to :create                   }
    it { should respond_to :delete                   }
    it { should respond_to :create_pending           }
    it { should respond_to :delete_pending           }
  end

  describe ".pending_delete" do
    it "returns an array" do
      expect(subject.pending_delete).to be_an(Array)
    end
  end

  describe ".pending_create" do
    it "returns an array" do
      expect(subject.pending_create).to be_an(Array)
    end
  end
end