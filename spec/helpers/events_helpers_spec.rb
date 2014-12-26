require "spec_helper"
require "#{HLP}/events_helpers"

class EventsMock
  include EventsHelpers
end

describe EventsMock do
  let(:klas) { described_class     }
  subject    { described_class.new }

  describe "Object" do
    specify { expect(klas).to be_a(Class) }
  end

  describe "Instance Methods" do
    it { should respond_to :range_start       }
    it { should respond_to :range_finish      }
    it { should respond_to :event_meetings    }
    it { should respond_to :event_trainings   }
    it { should respond_to :event_others      }
    it { should respond_to :calendar_table    }
    it { should respond_to :detail_table      }
  end

  describe "display functions" do
    describe "#range_start" do
      it "returns a string" do
        expect(subject.range_start).to be_a(String)
      end
    end
  end

  describe "scopes" do
    describe "#event_meetings" do
      it "returns an object" do
        expect(subject.event_meetings).to be_a(Hash)
      end
    end
  end

  describe "event rendering" do
    describe "#calendar_table" do
      it "renders meetings" do
        expect(subject.calendar_table(subject.event_meetings)).to be_a(String)
      end
      it "renders trainings" do
        expect(subject.calendar_table(subject.event_trainings)).to be_a(String)
      end
    end
  end
end
