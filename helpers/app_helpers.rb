require 'active_support'

require 'yaml'
require_relative "../lib/base"

module AppHelpers

  puts "MM_ROOT is #{MM_ROOT}"

  QUOTES       = YAML.load_file(MM_ROOT + "/assets/quotes.yaml")
  RIGHT_NAV    = YAML.load_file(MM_ROOT + "/assets/right_nav.yaml")
  GUEST_POLICY = File.read(MM_ROOT      + "/assets/guest_policy.html")
  SUBSCRIBE    = File.read(MM_ROOT      + "/assets/calendar_subscribe.html")
  PHOTO_LEFT   = File.read(MM_ROOT      + "/assets/photo_caption_left.html")
  PHOTO_RIGHT  = File.read(MM_ROOT      + "/assets/photo_caption_right.html")
  DONATE_LEFT  = File.read(MM_ROOT      + "/assets/donate_left.html")

  # ----- misc helpers -----

  def dot_hr
    '<img src="images/assets/dots.gif" width="134" height="10" border="0"><br>'
  end

  def menu_link(target, label)
    cls = current_page.destination_path == target ? "nav4" : "nav1"
    <<-HTML
      <a href='#{target}' class='#{cls}' onfocus='blur();'>#{label}</a><br/>
    HTML
  end

  def blog_url
    "http://bamru.blogspot.com"
  end

  # ----- sidebar helpers -----

  def eval_cmd(string)
    return "" if string.blank?
    begin
      eval string
    rescue
      "Unrecognized command: #{string}"
    end
  end

  def quote
    index = rand(QUOTES.length)
    <<-HTML
        <br/><p/>
        <img src="images/assets/axe.gif" border="0">
        <div class='quote_box'>
          <div class='quote'>"#{QUOTES[index][:text]}"</div>
          <div class='caps'>- #{QUOTES[index][:auth]}</div>
        </div>
    HTML
  end

  def right_nav(page)
    fmt = "nav4"
    RIGHT_NAV[page].reduce("") do |a, v|
      val = RIGHT_NAV[page].nil? ? "" : right_link(v.last, v.first, fmt)
      fmt = "nav3"
      a << val
    end
  end

  def right_link(target, label, fmt="nav3")
    "<a href='#{target}' class='#{fmt}' onfocus='blur();'>#{label}</a><br/>"
  end
end