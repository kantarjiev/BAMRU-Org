require_relative "../base"

require_relative "../cal_data/bnet/download"
require_relative "../cal_data/bnet/refine"

namespace :data do
  namespace :bnet do

    desc "Download event data from BAMRU.net"
    task :download do
      CalData::Bnet::Download.execute
    end

    desc "Refine BNET csv data to YAML"
    task :refine do
      CalData::Bnet::Refine.new.execute
    end

  end
end

if File.exist?(CLIENT_SECRET)
  require_relative "../cal_data/gcal/download"
  require_relative "../cal_data/gcal/refine"
  require_relative "../gcal_sync"

  namespace :data do
    namespace :gcal do

      desc "Download Gcal Data"
      task :download do
        CalData::Gcal::Download.execute
      end

      desc "Refine Gcal json data to YAML"
      task :refine do
        CalData::Gcal::Refine.new.execute
      end

      desc "Sync all Gcal Data"
      task :sync do
        GcalSync.new.sync
      end

      desc "Delete all Gcal Data! Admin function: USE WITH CARE!!"
      task :delete_all do
        GcalSync.new.delete_all
      end

    end
  end
end
