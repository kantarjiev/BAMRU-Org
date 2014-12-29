require_relative "../base"

require_relative "../cal_data/bnet/download"
require_relative "../cal_data/bnet/convert"

namespace :cal_data do
  namespace :bnet do
    desc "Download event data from BAMRU.net"
    task :download do
      BnetData::Download.execute
    end

    desc "Convert BNET csv data to YAML"
    task :convert do
      BnetData::Convert.new.execute
    end
  end
end

if File.exist?(ENV_FILE)
  require_relative "../cal_data/gcal/download"
  require_relative "../cal_data/gcal/convert"
  require_relative "../gcal_sync"

  namespace :cal_data do
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
