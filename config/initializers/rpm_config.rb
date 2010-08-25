if Rails.env.staging? || Rails.env.production?
  begin
    require "newrelic_rpm"
  rescue LoadError
  end
end