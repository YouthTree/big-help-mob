require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module Bighelpmob
  class Application < Rails::Application
    # config.plugins                 = [ :exception_notification, :ssl_requirement, :all ]
    # config.time_zone               = 'Central Time (US & Canada)'
    # config.i18n.load_path         += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
    # config.i18n.default_locale     = :de

    config.generators do |g|
      g.orm             :active_record
      g.template_engine :haml
      g.test_framework  :test_unit, :fixture_replacement => :machinist
    end

    config.filter_parameters << :password
    config.filter_parameters << :password_confirmation
    
    config.load_paths += [config.root.join("app", "drops").to_s, config.root.join("app", "observers").to_s]
    
    require Rails.root.join("lib/request_uuid_marker")
    config.middleware.insert_after 'Rails::Rack::Logger', RequestUUIDMarker
    
  end
end
