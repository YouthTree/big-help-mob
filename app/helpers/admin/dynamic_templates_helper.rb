module Admin::DynamicTemplatesHelper
  
  def preview_of_dt(dt)
    case dt.content_type
    when "html"
      content_tag(:div, dt.content.html_safe, :class => 'content-preview')
    when "text"
      content_tag(:pre, dt.content, :class => 'content-preview')
    end
  end
  
end
