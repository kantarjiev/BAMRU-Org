require "spec_helper"

## Test creation and synchronous of Google Calendar events

describe "Google Calendar test" do

  describe "'rake data:gcal:delete_all'" do
    it "resets to a known state without errors" do
      output = `rake data:gcal:delete_all 2>&1`
      expect(output.include? "ERROR").to be false
      File.delete "../#{BNET_DATA_YAML_FILE}" if File.exists?  "../#{BNET_DATA_YAML_FILE}"
      File.delete "../#{GCAL_DATA_YAML_FILE}" if File.exists?  "../#{GCAL_DATA_YAML_FILE}"
      File.delete "../#{GCAL_DATA_JSON_FILE}" if File.exists?  "../#{GCAL_DATA_JSON_FILE}"
    end
  end

  describe "'rake data:bnet:gen_data'" do
    it "creates dataset without errors" do
      output = `rake data:bnet:gen_data 2>&1`
      expect(count(output, "Saved 8 events", 1)).to be true
    end
  end

  describe "'rake data:bnet:refine'" do
    it "refines dataset without errors" do
      output = `rake data:bnet:refine 2>&1`
      expect(count(output, "Saved 8 events", 1)).to be true
    end
  end

  describe "'rake data:gcal:download'" do
    it "download dataset without errors" do
      output = `rake data:gcal:download 2>&1`
      expect(count(output, "Saved 0 events", 1)).to be true
    end
  end

  describe "'rake data:gcal:refine'" do
    it "refine dataset without errors" do
      output = `rake data:gcal:refine 2>&1`
      expect(count(output, "Saved 0 events", 1)).to be true
    end
  end

  describe "'rake data:gcal:sync'" do
    it "sync dataset without errors" do
      output = `rake data:gcal:sync 2>&1`
      expect(count(output, "Removed 0 events", 1)).to be true
      expect(count(output, "CREATED:", 8)).to be true
      expect(count(output, "Created 8 events", 1)).to be true
    end
  end

  # Run the process again, events shouldn't be deleted or created
  
  describe "'rake data:bnet:gen_data'" do
    it "creates dataset without errors (take 2)" do
      output = `rake data:bnet:gen_data 2>&1`
      expect(count(output, "Saved 8 events", 1)).to be true
    end
  end

  describe "'rake data:bnet:refine'" do
    it "refines dataset without errors (take 2)" do
      output = `rake data:bnet:refine 2>&1`
      expect(count(output, "Saved 8 events", 1)).to be true
    end
  end

  describe "'rake data:gcal:download'" do
    it "download dataset without errors (take 2)" do
      output = `rake data:gcal:download 2>&1`
      expect(count(output, "Saved 8 events", 1)).to be true
    end
  end

  describe "'rake data:gcal:refine'" do
    it "refine dataset without errors (take 2)" do
      output = `rake data:gcal:refine 2>&1`
      expect(count(output, "Saved 8 events", 1)).to be true
    end
  end

  describe "'rake data:gcal:sync'" do
    it "sync dataset without errors (take 2)" do
      output = `rake data:gcal:sync 2>&1`
      expect(count(output, "Removed 0 events", 1)).to be true
      expect(count(output, "Created 0 events", 1)).to be true
    end
  end

  private

  def count(s, word, n)
    s.scan(/#{word}/).count == n
  end
  
end
