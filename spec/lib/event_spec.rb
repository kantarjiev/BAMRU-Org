require "spec_helper"
require "#{LIB}/event"

describe Event do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe "Object" do
    specify { expect(klas).to be_a(Class) }
  end

  describe "Attributes" do
    it { should respond_to :kind                     }
    it { should respond_to :title                    }
    it { should respond_to :location                 }
    it { should respond_to :leaders                  }
    it { should respond_to :start                    }
    it { should respond_to :finish                   }
    it { should respond_to :description              }
    it { should respond_to :lat                      }
    it { should respond_to :lon                      }
    it { should respond_to :prior                    }
    it { should respond_to :gcal_id                  }
  end

  describe "Instance Methods" do
    it { should respond_to :id                     }
    it { should respond_to :hash                   }
  end
end