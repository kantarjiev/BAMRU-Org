require_relative "../base"

require_relative "../cal_data/bnet/download"
require_relative "../cal_data/bnet/sanitize"

namespace :data do
  namespace :bnet do
    desc "Download event data from BAMRU.net"
    task :download do
      CalData::Bnet::Download.execute
    end

    desc "Sanitize BNET csv data to YAML"
    task :sanitize do
      CalData::Bnet::Sanitize.new.execute
    end
  end
end

if File.exist?(ENV_FILE)
  require_relative "../cal_data/gcal/download"
  require_relative "../cal_data/gcal/sanitize"
  require_relative "../gcal_sync"

  namespace :data do
    namespace :gcal do
      desc "Download Gcal Data"
      task :download do
        CalData::Gcal::Download.execute
      end

      desc "Sanitize Gcal json data to YAML"
      task :sanitize do
        CalData::Gcal::Sanitize.new.execute
      end

      desc "Sync all Gcal Data"
      task :sync do
        GcalSync.new.sync
      end
    end
  end
end
