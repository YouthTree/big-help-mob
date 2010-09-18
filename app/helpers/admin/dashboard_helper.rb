module Admin::DashboardHelper

  def clicky_meta_tags
    clicky = Settings.clicky
    extra_head_content(meta_tag("clicky-site-id", clicky.site_id))   if clicky.site_id?
    extra_head_content(meta_tag("clicky-site-key", clicky.site_key)) if clicky.site_key?
    nil
  end

  def postcode_location_opts(location)
    {
      "data-postcode-lat"   => location.lat,
      "data-postcode-lng"   => location.lng,
      "data-postcode"       => location.postcode,
      "data-postcode-count" => location.count
    }
  end
  
  def use_postcode_mapper(sensor = false)
    unless defined?(@use_postcode_mapper) && @use_postcode_mapper
      has_js "http://maps.google.com/maps/api/js?sensor=#{sensor}"
      has_jammit_js :postcode_mapper
      @use_postcode_mapper = true
    end
  end
  
  def dl_for_stat(statistic)
    inner = ActiveSupport::SafeBuffer.new
    statistic.each_pair do |k, v|
      inner << content_tag(:dt, k)
      inner << content_tag(:dd, v)
    end
    content_tag(:dl, inner)
  end
  
end
