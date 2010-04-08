module MapHelper
  
  # Given an array of addresses, will return an image an
  # image tag with a static google map plotting those points.
  def static_map_of_addresses(addresses, options = {})
    image_tag(StaticGoogleMap.for_addresses(addresses, options), :alt => "#{pluralize addresses.size, "address"} plotted on a map")
  end
  
  # Returns an image map with a single address plotted on a single static google map.
  def static_map_of_address(address, options = {})
    image_tag(StaticGoogleMap.for_address(address, options), :alt => address.to_s)
  end
  
  # Draws a map of a given address. Not only creates a container div
  # for gmap to correctly draw the map along with the correct unobtrusive
  # html in order for gmap.js to draw a dynamic version of the map.
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
  
  # Include the google maps in the header unless it already has been called before.
  def use_gmaps_js(sensor = false)
    return if defined?(@gmaps_used) && @gmaps_used
    has_js "http://maps.google.com/maps/api/js?sensor=#{sensor}"
    has_jammit_js :gmap
    @gmaps_used = true
  end
  
  
  
end