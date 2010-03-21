require 'ninesixty'
require 'compass-colors'
require 'fancy-buttons'

project_type    = :rails
project_path    = Rails.root.to_s if defined?(Rails.root)
http_path       = "/"
css_dir         = "public/stylesheets"
sass_dir        = "app/stylesheets"
environment     = Compass::AppIntegration::Rails.env
relative_assets = true
output_style    = Rails.env.production? ? :compressed : :expanded