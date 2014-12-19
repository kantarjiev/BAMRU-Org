require 'pstore'
require 'colored'

HDR = <<-EOF
---
headline: MV Condo - CL Data
title: TBD
subhead: A comfortablehome for Mesa Verde visitors!
---
EOF

module ClGenerate

  LIB_DIR = __dir__
  PRJ_DIR = File.expand_path('../', LIB_DIR)
  SRC_DIR = "#{PRJ_DIR}/src"

  def data
    store = PStore.new("#{PRJ_DIR}/old/cl.pstore")
    store.transaction do
      store.roots.reduce({}) {|a,v| a[v] = store[v]; a}
    end
  end

  def current_data
    tmp = data
    current_key = tmp.keys.sort.last
    current_dat = tmp[current_key]
    [current_key, current_dat]
  end


  def ad_count(ads)
    ads.length
  end

  def ad_rents(ads)
    ads.map {|x| x["rent"].gsub(/[\$\,]/,'').to_i}.select {|x| x != 0}
  end

  def ad_high(ads)
    ad_rents(ads).max
  end

  def ad_low(ads)
    ad_rents(ads).min
  end

  def ad_avg(ads)
    list = ad_rents(ads)
    (list.reduce(:+).to_f / list.size).round
  end

  def write_history
    File.open("#{SRC_DIR}/data_history.html.erb", 'w') do |f|
      f.puts HDR.gsub("TBD", "History")
      f.puts <<-EOF
      <a href="data_current.html">View Current Listings</a>
      <div id="report">
      <h2>Historical Data</h2>
      <table>
        <tr><th>Date</th><th># Ads</th><th>High</th><th>Low</th><th>Avg.</th></tr>
      EOF
      keys = data.keys.sort.reverse
      keys.each do |date|
        ads = data[date]
        f.puts <<-EOF
        <tr>
        <td>#{date}</td>
        <td>#{ad_count(ads)}</td>
        <td>$#{ad_high(ads)}</td>
        <td>$#{ad_low(ads)}</td>
        <td>$#{ad_avg(ads)}</td>
        </tr>
        EOF
      end
      f.puts "</table></div>"
    end
  end

  def write_current
    key, list = current_data
    File.open("#{SRC_DIR}/data_current.html.erb", 'w') do |f|
      f.puts HDR.gsub("TBD", "Current")
      f.puts <<-EOF
    <a href="data_history.html">View Historical Data</a>
    <div id="report">
    <h2>Current Listings for #{key}</h2>
    <table>
      <tr><th>Link</th><th>Text</th><th>Rent</th></tr>
      EOF
      list.each_with_index do |hash, idx|
        path = "http://westslope.craigslist.org#{hash['href']}"
        link = "<a href='#{path}' target='_blank'>#{idx + 1}</a>"
        f.puts <<-EOF
      <tr>
      <td>#{link}</td>
      <td>#{hash["text"]}</td>
      <td>#{hash["rent"]}</td>
      </tr>
        EOF
      end
      f.puts "</table></div>"
    end
  end

end

