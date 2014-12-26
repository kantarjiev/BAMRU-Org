require "spec_helper"
require "#{LIB}/event/store"

TEST_FILE = "/tmp/test.yaml"

describe Event::Store do
  let(:klas) { described_class            }
  subject    { klas.new(TEST_FILE)        }

  describe "Object" do
    specify { expect(klas).to be_a(Class) }
  end

  describe "Attributes" do
    it { should respond_to :data_file          }
    it { should respond_to :store              }
  end

  describe "Instance Methods" do
    it { should respond_to :all          }
    it { should respond_to :find         }
    it { should respond_to :create       }
    it { should respond_to :destroy_all  }
  end

  describe "Store Operations" do
    before(:each) { `rm -f #{TEST_FILE}` }

    describe "#all" do
      context "with an empty store" do
        it "returns an empty hash" do
          expect(subject.all).to eq({})
        end
      end
    end

    describe "#create" do
      it "creates a data key" do
        value = "HELLO WORLDDD"
        keys = subject.create(value)
        expect(keys[0]).to be_a(String)
      end
    end

    describe "#find" do
      context "with an empty store" do
        it "returns nil" do
          expect(subject.find("badkey")).to eq(nil)
        end
      end

      context "with a data element" do
        it "returns the value" do
          value = "HELLO WORLDDD"
          keys  = subject.create(value)
          expect(subject.find(keys[0])).to eq(value)
        end
      end
    end
  end
end