module ApplicationHelper
  
  def tu(name, options = {})
    scope = [:ui, options.delete(:scope)].compact.join(".").to_sym
    I18n.t(name, options.merge(:scope => scope))
  end
  
  def flash_messages(*names)
    names = names.select { |k| flash[k].present? }
    return if names.blank?
    content = []
    names.each_with_index do |key, idx|
      value = flash[key]
      first, last = (idx == 0), (idx == names.length - 1)
      content << content_tag(:p, value, :class => "flash #{key} #{"first" if first} #{"last" if last}".strip)
    end
    content_tag(:section, content.join, :id => "flash-messages").html_safe
  end
  
  def has_jammit_js(*args)
    content_for(:extra_head, raw(include_javascripts(*args)))
  end
  
  def has_jammit_css(*args)
    content_for(:extra_head, raw(include_stylesheets(*args)))
  end
  
  def has_js(*args)
    content_for(:extra_head, javascript_include_tag(*args))
  end
  
  def pickup_data_options(pickup, selected = false)
    opts = {:title => pickup.address.to_s, :class => "pickup-entry"}
    opts["data-pickup-latitude"]  = pickup.address.lat
    opts["data-pickup-longitude"] = pickup.address.lng
    opts["data-pickup-id"]        = pickup.id
    opts["data-pickup-selected"]  = pickup.id if selected
    opts["data-pickup-name"]      = pickup.name
    opts["data-pickup-address"]   = pickup.address.to_s
    opts
  end
  
  def copyright(year, now=Time.now)
    if now.year == year
      year.to_s
    elsif year / 1000 == now.year / 1000 # same century
      year.to_s + "&ndash;" + now.year.to_s[-2..3]
    else
      year.to_s + "&ndash;" + now.year.to_s
    end
  end
  
  def sponsor_link(name, url)
    link_to image_tag("sponsors/#{name.underscore.gsub(/[\ \_]+/, "-")}-logo.jpg"), url, :title => name, :class => 'sponsor'
  end
  
  
  def render_address_fields(f, name = :address, options = {})
    o = f.object
    o.send(:"build_#{name}") if o.send(name).blank?
    capture do
      f.fields_for(name) do |af|
        concat render(:partial => 'shared/address_fields', :locals => {:form => af, :options => options})
      end
    end.html_safe
  end
  
  protected
  
  def normalized_content_scope(key, scope = nil)
    (Array(scope) + key.to_s.split(".")).flatten.join(".")
  end
  
  def options_with_class_merged(o, n)
    css_klass = [o[:class], n[:class]].join(" ").strip.squeeze(" ")
    o.merge(n).merge(:class => css_klass)
  end
  
end
