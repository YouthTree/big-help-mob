module ContentHelper
  
  def static_map_of_addresses(addresses, options = {})
    image_tag(StaticGoogleMap.for_addresses(addresses, options), :alt => "#{pluralize addresses.size, "address"} plotted on a map")
  end
  
  def static_map_of_address(address, options = {})
    image_tag(StaticGoogleMap.for_address(address, options), :alt => address.to_s)
  end
  
  def draw_map_of(address, options = {})
    use_gmaps_js
    lat, lng = address.lat, address.lng
    if lat.present? && lng.present?
      options[:class] = [options[:class].to_s.split(" "), "gmap static-google-map"].join(" ").squeeze(" ")
      options["data-latitude"]  = lat
      options["data-longitude"] = lng
      marker_opts = options.delete(:marker) || {}
      marker_opts[:title] ||= address.to_s
      marker_opts.each_pair { |k, v| options["data-marker-#{k.to_s.gsub("_", "-")}"] = v }
      content_tag(:div, static_map_of_address(address, marker_opts.merge(options.delete(:map) || {})), options)
    end
  end
  
  def use_gmaps_js(sensor = false)
    unless defined?(@gmaps_used) && @gmaps_used
      has_js "http://maps.google.com/maps/api/js?sensor=#{sensor}"
      has_jammit_js :gmap
      @gmaps_used = true
    end
  end
  
  def has_ckeditor
    has_jammit_js :ckeditor
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
  
  def faq(questions, title = "Frequently Asked Questions")
    return if questions.blank?
    inner = ActiveSupport::SafeBuffer.new
    faqs  = ActiveSupport::SafeBuffer.new
    questions.each_with_index do |question, idx|
      faqs << content_tag(:dt, question.question, :class => (idx == 0 ? "first" : nil))
      faqs << content_tag(:dd, question.answer_as_html)
    end
    inner << content_tag(:h3, title)
    inner << content_tag(:dl, faqs, :class => "frequently-asked-questions")
    inner
  end
  
  def has_share_this_js
    if Settings.share_this.publisher?
      has_js "http://w.sharethis.com/button/sharethis.js#publisher=#{Settings.share_this.publisher}&amp;type=website&amp;button=false"
      has_jammit_js :share_this
    end
  end
  
  def share_this_link(text, options = {})
    target = options.delete(:for)
    options.stringify_keys!
    options["data-share-this-target"] = target.to_s if target
    options[:class] = [options[:class], 'share-this'].join(" ").squeeze(" ")
    link_to(text, '#', options)
  end
  
  def social_media_link(name, text, link)
    link_to text.html_safe, link, :title => text, :class => "social-media-link #{name.to_s.dasherize}"
  end
  
end