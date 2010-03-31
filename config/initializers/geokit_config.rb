if defined? Geokit
	Geokit.default_units              = :kms
	Geokit.default_formula            = :sphere
	Geokit::Geocoders.request_timeout = 3
	Geokit::Geocoders.proxy_addr      = nil
	Geokit::Geocoders.proxy_port      = nil
	Geokit::Geocoders.proxy_user      = nil
	Geokit::Geocoders.proxy_pass      = nil
  Geokit::Geocoders.yahoo           = false
	Geokit::Geocoders.geocoder_us     = false 
	Geokit::Geocoders.geocoder_ca     = false

	
	Geokit::Geocoders.google = 'ABQIAAAAnFHZWmJapmxv0fZy7Rx5zRTchCX1BV_uFoek8vqWWdvBGyFeLhRMhe5ReczMTt5NiZX1leFbGcOW-A'
	Geokit::Geocoders.provider_order = [:google]
end
