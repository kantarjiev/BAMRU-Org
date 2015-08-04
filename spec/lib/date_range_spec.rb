require "spec_helper"
require "#{LIB}/helpers/date_range"

describe DateRange do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe "Object" do
    specify { expect(klas).to be_a(Class) }
  end

  describe "Instance Methods" do
    specify { expect(klas).to respond_to :start                  }
    specify { expect(klas).to respond_to :finish                 }
    specify { expect(klas).to respond_to :start_str              }
    specify { expect(klas).to respond_to :finish_str             }
    specify { expect(klas).to respond_to :start_month            }
    specify { expect(klas).to respond_to :finish_month           }
  end
end
