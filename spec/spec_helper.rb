ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'dataset'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rr
  config.use_transactional_fixtures = true
  # reset stuff before tests.
  config.before(:each) { Machinist.reset_before_test }
  config.before(:all) do
    CollatableOptionSeeder.seed 'user.gender'
    CollatableOptionSeeder.seed 'subscriber.volunteering_history'
  end
  config.include DatasetExtension
end

