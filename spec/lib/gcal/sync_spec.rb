require "spec_helper"

if File.exist?(CLIENT_SECRET)
  require "#{LIB}/gcal/sync"

  describe Gcal::Sync do
    let(:klas) { described_class }
    subject    { klas.new        }

    describe "Object" do
      specify { expect(klas).to be_a(Class) }
    end

    describe "Instance Methods" do
      it { should respond_to :sync                 }
      it { should respond_to :delete_all           }
    end

    describe "_pending_delete" do
      it "returns an array" do
        expect(subject.send(:pending_delete)).to be_an(Array)
      end
    end

    describe "_pending_create" do
      it "returns an array" do
        expect(subject.send(:pending_create)).to be_an(Array)
      end
    end
   end
end
