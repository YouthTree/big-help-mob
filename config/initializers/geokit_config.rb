if defined?(Geokit)
  Geokit::Geocoders.request_timeout = 3
  Geokit::Geocoders.proxy_addr      = nil
  Geokit::Geocoders.proxy_port      = nil
  Geokit::Geocoders.proxy_user      = nil
  Geokit::Geocoders.proxy_pass      = nil	
  Geokit::Geocoders.google          = Settings.google.geocoder
  Geokit::Geocoders.provider_order  = [:google]
end