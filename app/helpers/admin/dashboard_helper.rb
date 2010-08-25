module Admin::DashboardHelper

  def clicky_meta_tags
    clicky = Settings.clicky
    extra_head_content(meta_tag("clicky-site-id", clicky.site_id))   if clicky.site_id?
    extra_head_content(meta_tag("clicky-site-key", clicky.site_key)) if clicky.site_key?
    nil
  end

  def site_visits_url
    data = @site_visits
    GoogleChart.Bar do |c|
      c.extend GchartExtensions
      c.axes            = {:x => labels(data.keys.map{ |t| t.to_s(:short) }, 3), :y => (0..(data.values.max))}
      c.data            = data.values
      c.encoding        = :extended
      c.color           = '48993C'
      c.background_fill = 'F9F9F9'
      c.size            = '680x200'
    end
  end

  def user_stats_url
    data = @user_stats
    GoogleChart.Line do |c|
      c.extend GchartExtensions
      c.axes            = {:x => labels(data.keys.map(&:to_s), 5), :y => (0..(data.values.max))}
      c.data            = data.values
      c.encoding        = :extended
      c.color           = '48993C'
      c.background_fill = 'F9F9F9'
      c.size            = '680x200'
    end
  end
  
  def user_ages_url
    data = @user_ages
    GoogleChart.Bar do |c|
      c.extend GchartExtensions
      c.axes            = {:x => data.keys.map(&:to_s), :y => (0..(data.values.max))}
      c.data            = data.values
      c.encoding        = :extended
      c.color           = '48993C'
      c.background_fill = 'F9F9F9'
      c.size            = '680x200'
    end
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

  def user_origins_url
    PieChart.new(@origin_counts).to_url
  end
  
  protected
  
  def labels(all, count = 3)
    inside_count         = count - 2
    labels               = Array.new(all.size, "")
    count                = all.size / (inside_count + 1)
    current = count
    labels[0] = all.first
    while current < (all.size - 1)
      labels[current] = all[current]
      current += count
    end
    labels[labels.length] = all.last
    labels
  end
  
end
