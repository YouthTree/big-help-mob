module ApplicationHelper
  
  def flash_messages(*names)
    content = []
    names.each do |key|
      value = flash[key]
      content << content_tag(:p, value, :class => "flash #{key}") if value.present?
    end
    if content.empty?
      ""
    else
      content_tag(:section, content.join, :id => "flash-messages").html_safe
    end
  end
  
end
