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
  
  def draw_map_of(address, options = {})
    use_gmaps_js
    lat, lng = address.lat, address.lng
    if lat.present? && lng.present?
      options[:class] = [options[:class].to_s.split(" "), "gmap"].join(" ").squeeze(" ")
      options["data-latitude"]  = lat
      options["data-longitude"] = lng
      marker_opts = options.delete(:marker) || {}
      marker_opts[:title] ||= address.to_s
      marker_opts.each_pair { |k, v| options["data-marker-#{k.to_s.gsub("_", "-")}"] = v }
      content_tag(:div, "&nbsp;", options)
    end
  end
  
  def use_gmaps_js(sensor = false)
    unless defined?(@gmaps_used) && @gmaps_used
      has_js "http://maps.google.com/maps/api/js?sensor=#{sensor}", "gmap"
      @gmaps_used = true
    end
  end
  
  def has_js(*args)
    content_for(:extra_head, javascript_include_tag(*args))
  end
  
  def pickup_data_options(pickup, selected = false)
    opts = {:title => pickup.address.to_s, :class => "pickup-entry"}
    opts["data-pickup-title"]     = "#{pickup.name} - #{pickup.address}"
    opts["data-pickup-latitude"]  = pickup.address.lat
    opts["data-pickup-longitude"] = pickup.address.lng
    opts["data-pickup-id"]        = pickup.id
    opts["data-pickup-selected"]  = pickup.id if selected
    opts
  end
  
  def has_ckeditor
    has_js '/ckeditor/ckeditor.js', '/ckeditor/adapters/jquery.js', 'bhm/ck_editor.js'
  end
  
  def content_section(key, options = {})
    content = Content[normalized_content_scope(key, options.delete(:scope))]
    div_options = options_with_class_merged(options, :class => "embedded-content #{key.gsub(".", "-")}")
    content_tag(:div, content.try(:content_as_html).to_s, div_options)
  end

  alias cs content_section
  
  protected
  
  def normalized_content_scope(key, scope = nil)
    (Array(scope) + key.to_s.split(".")).flatten.join(".")
  end
  
  def options_with_class_merged(o, n)
    css_klass = [o[:class], n[:class]].join.strip.squeeze(" ")
    o.merge(n).merge(:class => css_klass)
  end
  
end
