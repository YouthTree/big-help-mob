# Configure Flickr.
if Settings.flickr_api?
  FlickRaw.api_key       = Settings.flickr_api.api_key
  FlickRaw.shared_secret = Settings.flickr_api.secret
end
