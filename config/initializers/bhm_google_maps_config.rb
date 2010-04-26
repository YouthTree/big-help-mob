BHM::GoogleMaps.include_js_proc = proc do |t|
  t.has_js t.google_maps_url(false)
  t.has_jammit_js :gmap
end