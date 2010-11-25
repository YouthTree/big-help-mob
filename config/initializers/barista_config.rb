Barista.configure do |c|
  c.bare!
  c.change_output_prefix! 'bhm-google-maps', 'vendor/bhm-google-maps'
  c.change_output_prefix! 'shuriken',        'vendor/shuriken'
  c.change_output_prefix! 'youthtree',       'vendor/youthtree'
  # Vendor in CoffeeScript 0.9.5
  c.js_path = Rails.root.join('public', 'javascripts', 'vendor', 'coffee-script-0.9.5.js').to_s
end