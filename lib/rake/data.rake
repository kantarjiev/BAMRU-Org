require_relative "../base"

require_relative "../bnet/download"
require_relative "../bnet/refine"
require_relative "../bnet/gendata"

namespace :data do
  namespace :bnet do
    desc "Download event data from BAMRU.net"
    task :download do
      Bnet::Download.execute
    end

    desc "Refine BAMRU.net csv data to YAML"
    task :refine do
      Bnet::Refine.new.execute
    end

    desc "Generate test data (use this in place of Download)"
    task :gen_data do
      Bnet::GenTestData.execute
    end
  end
end

if File.exist?(CLIENT_SECRET)
  require_relative "../gcal/download"
  require_relative "../gcal/refine"
  require_relative "../gcal/sync"

  namespace :data do
    namespace :gcal do
      desc "Download Google Calendar data"
      task :download do
        Gcal::Download.execute
      end

      desc "Refine Google Calendar json data to YAML"
      task :refine do
        Gcal::Refine.new.execute
      end

      desc "Sync all Google Calendar data"
      task :sync do
        Gcal::Sync.new.sync
      end

      desc "Delete all Google Calendar data! Admin function: USE WITH CARE!!"
      task :delete_all => [:download, :refine] do
        Gcal::Sync.new.delete_all
      end
    end
  end
end
