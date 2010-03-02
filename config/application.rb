require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module Bighelpmob
  class Application < Rails::Application
    # config.load_paths             += %W( #{config.root}/extras )
    # config.plugins                 = [ :exception_notification, :ssl_requirement, :all ]
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
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
    
  end
end
