require "spec_helper"
require "#{LIB}/helpers/app_helpers"

class AppMock
  include AppHelpers
end

describe AppMock do
  let(:klas) { described_class     }
  subject    { described_class.new }

  describe "Object" do
    specify { expect(klas).to be_a(Class) }
  end

  describe "Instance Methods" do
    it { should respond_to :eval_cmd   }
    it { should respond_to :dot_hr     }
    it { should respond_to :blog_url   }
  end

  describe "#quote" do
    it "returns a string" do
      expect(subject.quote).to be_a(String)
    end
  end
end
