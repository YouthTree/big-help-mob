module ContentHelper
  
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
  
end