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
  
  def youtube_video(video_id, opts = {})
    options = {:height => 360, :width => 480, :color1 => 'AAAAAA', :color2 => '999999'}.merge(opts)
    video_url = "http://www.youtube-nocookie.com/v/#{video_id}?hl=en_US&fs=1&rel=0&color1=0x#{options[:color1]}&color2=0x#{options[:color2]}"
    inner = returning([]) do |i|
      i << tag(:param, :name => "movie", :value => video_url)
      i << tag(:param, :name => "allowFullScreen", :value => "true")
      i << tag(:param, :name => "allowscriptaccess", :value => "always")
      i << tag(:embed, :src => video_url, :height => options[:height], :width => options[:width], :allowfullscreen => "true",
        :type => "application/x-shockwave-flash", :allowscriptaccess => "always")
    end
    content_tag(:object, inner.join, :height => options[:height], :width => options[:width])
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
  
  def rpxnow_link(text, url, opts = {})
    has_rpxnow
    options = options_with_class_merged(opts, :class => 'rpxnow')
    rpx_opts = options.delete(:rpx) || {}
    auth_token_params = [Rack::Utils.escape(request_forgery_protection_token.to_s), Rack::Utils.escape(form_authenticity_token.to_s)] * "="
    token_url = "#{url}#{url.include?("?") ? "&" : "?"}#{auth_token_params}"
    rpx_opts[:realm]     ||= RPXNOW_CONFIG.realm
    rpx_opts[:token_url]   = token_url
    rpx_opts.each_pair do |k, v|
      options["data-rpxnow-#{k.to_s.gsub("_", "-")}"] = v
    end
    full_url = "http://#{rpx_opts[:realm]}.rpxnow.com/openid/v2/signin?token_url=#{Rack::Utils.escape(token_url)}"
    link_to text, full_url, options
  end
  
  def has_rpxnow
    return if defined?(@has_rpxnow) && @has_rpxnow
    rpxnow_js = "#{request.ssl? ? 'https://' : 'http://static.'}rpxnow.com/js/lib/rpx.js"
    has_js rpxnow_js, 'bhm/rpx_now'
    @has_rpxnow = true
  end
  
  protected
  
  def normalized_content_scope(key, scope = nil)
    (Array(scope) + key.to_s.split(".")).flatten.join(".")
  end
  
  def options_with_class_merged(o, n)
    css_klass = [o[:class], n[:class]].join.strip.squeeze(" ")
    o.merge(n).merge(:class => css_klass)
  end
  
end
