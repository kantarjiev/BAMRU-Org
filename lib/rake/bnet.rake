require_relative "../bnet_data/download"
require_relative "../bnet_data/convert"

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