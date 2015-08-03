require "spec_helper"

# if File.exist?(ENV_FILE)

  require "#{LIB}/gcal/client"

  describe Gcal::Client do
    let(:klas) { described_class }
    subject    { klas.new        }

    describe "Object" do
      specify { expect(klas).to be_a(Class) }
    end

    describe "Instance Methods" do
      it { should respond_to :list_events                }
      it { should respond_to :create_event               }
      it { should respond_to :delete_event               }
    end
  end

# end