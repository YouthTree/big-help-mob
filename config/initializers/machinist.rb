
begin
  require 'machinist/active_record'
  Machinist.configure do |config|
    config.cache_objects = false
  end
rescue LoadError
end