ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'dataset'

spec_dir = Rails.root.join("spec")

Dir[spec_dir.join("support/**/*.rb")].each { |f| require f }

RSpec::Core::ExampleGroup.class_eval do
  include Dataset
  datasets_directory spec_dir.join("datasets").to_s
end

RSpec.configure do |config|
  config.mock_with :rr
  config.fixture_path               = spec_dir.join("fixtures").to_s
  config.use_transactional_fixtures = true
  # reset stuff before tests.
  config.before(:each) { Machinist.reset_before_test }
  config.before(:all) do
    CollatableOptionSeeder.seed 'user.gender'
    CollatableOptionSeeder.seed 'subscriber.volunteering_history'
  end
end
