Rails.application.config.session_store :cookie_store, :key => Settings.fetch(:session_key, 'bhm-session')
Rails.application.config.secret_token = Settings.secret_key

if defined?(Carmen)
  Carmen.default_country = 'AU'
end

if defined?(Haml)
  Haml.init_rails(binding) if defined?(Haml)
  Haml::Template.options[:format] = :html5
end

if defined?(BHM::GoogleMaps)
  BHM::GoogleMaps.include_js_proc = proc do |t|
    t.has_js t.google_maps_url(false)
    t.has_jammit_js :gmap
  end
end

if defined?(FlickRaw) && Settings.flickr_api?
  FlickRaw.api_key       = Settings.flickr_api.api_key
  FlickRaw.shared_secret = Settings.flickr_api.secret
end

# Rails.backtrace_cleaner.add_silencer { |line| line =~ /my_noisy_library/ }
# Rails.backtrace_cleaner.remove_silencers!
# Mime::Type.register_alias "text/html", :iphone
Mime::Type.register 'application/pdf', :pdf

CampaignMonitorWrapper.configure!

require 'attr_accessible_scoping'