module ReportsHelper

  def screenshot_tag(report)
  	raw "<img src=\"data:image/gif;base64,#{report.screenshot}\">"
  end
  
  def status_title(status_code)
    if Report::STATUS.keys.size > status_code
      "#{Report::STATUS.keys[status_code]}".gsub('_', ' ').capitalize
    else 
      nil
    end
  end
  
  def dumped_view_to_html(dumped_view)
    if dumped_view
      safe_string = h(dumped_view)
      space = "&nbsp;&nbsp;"
      to_html = safe_string.gsub(/\|/, space)
    end
    to_html || dumped_view
  end
  
end
