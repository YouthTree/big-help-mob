require 'compass'
rails_root = Rails.root.to_s
Compass.add_project_configuration(Rails.root.join("config", "compass.rb").to_s)
Compass.configure_sass_plugin!
Compass.handle_configuration_change!
