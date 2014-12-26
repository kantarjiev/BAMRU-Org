require_relative "../gcal_data/download"
require_relative "../gcal_data/convert"

namespace :gcal do

  # def exit_with(msg)
  #   puts "Error: #{msg}"
  #   exit
  # end
  #
  # def find_event_id
  #   exit_with("No EVENT_ID") unless event_id = ENV["EVENT_ID"]
  #   event_id
  # end
  #
  # def find_event
  #   event_id = find_event_id
  #   exit_with("No records (id=#{event_id})") unless event = Event.find_by_id(event_id)
  #   event
  # end
  #
  # desc "Sync Calendar Data with Google Calendar"
  # task :sync do
  #   require File.dirname(File.expand_path(__FILE__)) + '/config/environment'
  #   GcalSync.sync
  # end
  #
  # desc "Create a Gcal Event"
  # task :create do
  #   GcalSync.create_event(find_event)
  # end
  #
  # desc "Update a Gcal Event"
  # task :update do
  #   GcalSync.update_event(find_event)
  # end
  #
  # desc "Delete a Gcal Event"
  # task :delete do
  #   GcalSync.delete_event(find_event_id)
  # end

  desc "Convert Gcal json data to YAML"
  task :convert do
    GcalData::Convert.new.execute
  end

  desc "Download Gcal Data"
  task :download do
    GcalData::Download.execute
  end
end
