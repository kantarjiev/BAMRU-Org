module AppHelpers
  def dot_hr
    '<img src="images/assets/dots.gif" width="134" height="10" border="0"><br>'
  end

  def menu_link(target, label)
    cls = current_page.destination_path == target ? "nav4" : "nav1"
    <<-HTML
      <a href='/#{target}' class='#{cls}' onfocus='blur();'>#{label}</a><br/>
    HTML
  end
end