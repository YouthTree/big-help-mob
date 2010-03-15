module ApplicationHelper
  
  def tu(name, options = {})
    scope = [:ui, options.delete(:scope)].compact.join(".").to_sym
    I18n.t(name, options.merge(:scope => scope))
  end
  
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
