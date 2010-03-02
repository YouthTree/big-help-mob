ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails/test_help'

require 'shoulda'
require 'redgreen' if RUBY_VERSION < '1.9'
Machinist.load_blueprints

class ActiveSupport::TestCase
end
