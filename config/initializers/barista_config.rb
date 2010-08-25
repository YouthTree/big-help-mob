Barista.configure do |c|
  c.no_wrap!
  c.change_output_prefix! 'bhm-google-maps', 'vendor/bhm-google-maps'
  c.change_output_prefix! 'shuriken',        'vendor/shuriken'
  c.change_output_prefix! 'youthtree',      'vendor/youthtree'
  
  if Rails.env.development?
    c.on_compilation_with_warning { |path, output| puts "Barista: Compilation of #{path} had a warning:\n#{output}" }
    c.on_compilation_error        { |path, output| puts "Barista: Compilation of #{path} failed with:\n#{output}" }
  end
  
end

Barista::Compiler.bin_path = "/usr/local/bin/coffee" if File.executable?("/usr/local/bin/coffee")