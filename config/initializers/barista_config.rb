Barista.configure do |c|
  c.bare!
  c.change_output_prefix! 'bhm-google-maps', 'vendor/bhm-google-maps'
  c.change_output_prefix! 'shuriken',        'vendor/shuriken'
  c.change_output_prefix! 'youthtree',       'vendor/youthtree'
end