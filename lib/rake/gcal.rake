require_relative "../base"

if File.exist?(ENV_FILE)
  require_relative "../gcal_data/convert"
  require_relative "../gcal_data/download"
  require_relative "../gcal_sync"

  namespace :data do
    namespace :gcal do
      desc "Convert Gcal json data to YAML"
      task :convert do
        GcalData::Convert.new.execute
      end

      desc "Download Gcal Data"
      task :download do
        GcalData::Download.execute
      end

      desc "Sync all Gcal Data"
      task :sync do
        GcalSync.new.sync
      end
    end
  end
end
