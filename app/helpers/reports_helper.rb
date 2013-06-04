module ReportsHelper

  def screenshot_tag(report)
  	raw "<img src=\"data:image/gif;base64,#{report.screenshot}\">"
  end

end
