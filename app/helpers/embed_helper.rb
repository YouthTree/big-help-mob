module EmbedHelper
  
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
    content_tag(:object, inner.join.html_safe, :height => options[:height], :width => options[:width])
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
  
  def google_analytics
    if Settings.google_analytics.identifier?
      inner = javascript_include_tag("#{request.ssl? ? "https://ssl" : "http://www"}.google-analytics.com/ga.js")
      inner << javascript_tag(google_analytics_snippet_js(Settings.google_analytics.identifier))
    end
  end
  
  def google_analytics_snippet_js(identifier)
    "try { var pageTracker = _gat._getTracker(#{identifier.to_json}); pageTracker._trackPageview(); } catch(e) {}"
  end
  
  def link_to(*args, &blk)
    options = args.extract_options!
    ga = options.delete(:ga)
    options.merge! options_to_ga_data(ga) if ga.present?
    args << options
    super(*args, &blk)
  end
  
  def options_to_ga_data(opts = {})
    Hash.new.tap do |options|
      opts.each_pair do |key, value|
        options[:"data-analytics-#{key.to_s.gsub("_", "-")}"] = value
      end
    end
  end
  
  def ga_link_to(text, url, ga = {})
    link_to text, url, :ga => ga
  end
  
end