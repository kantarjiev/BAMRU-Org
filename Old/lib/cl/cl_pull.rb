require 'craigslist'
require 'pstore'
require 'colored'
require 'net/http'
require 'uri'

module ClPull
  def open_ref(href)
    url = "http://westslope.craigslist.org#{href}"
    begin
      Net::HTTP.get(URI.parse(url))
    rescue
      puts ">>> can't read #{href}".red
      ""
    end
  end

  def price_for(href)
    sleep 2.0
    puts "> Getting rent for #{href}".yellow
    ad_txt = open_ref(href)
    match  = ad_txt.match(/(\$[\d\,]+)/)
    match ? match[0] : ""
  end

  def execute
    cat = Craigslist.westslope.category_path('apa')
    cat.limit = 1000
    cat.query = 'cortez'

    puts "--------------------------------------------".green
    puts "Fetching CL Data - #{Time.now}".yellow
    data_orig = cat.fetch
    data_filt = data_orig.select {|el| el["href"].match(/^\/apa/)}
    count = "(#{data_orig.length} original / #{data_filt.length} filtered)"
    puts "Retrieved records #{count}".yellow
    data_rent = data_filt.map {|el| el["rent"] = price_for(el["href"]); el}

    store = PStore.new("old/cl.pstore")
    today = Time.now.strftime("%Y-%m-%d")

    puts "Storing records".yellow

    store.transaction { store[today] = data_rent }

    puts "Done".yellow
  end
end
