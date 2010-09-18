require 'rspec/rails'
require 'rspec/core'
require 'rspec/core/rake_task'

#
# TODO: This is just here to fix the rcov_opts that the default rspec:rcov task
# uses which are missing the --rails option, can remove this whole file once
# that is fixed.
#
spec_prereq = Rails.configuration.generators.options[:rails][:orm] == :active_record ?  "db:test:prepare" : :noop
task :noop do; end
task :default => :spec

namespace :spec do
  RSpec::Core::RakeTask.new(:rcov => spec_prereq) do |t|
    t.rcov = true
    t.pattern = "./spec/**/*_spec.rb"
    t.rcov_opts = '--rails --exclude /gems/,/Library/,/usr/,lib/tasks,.bundle,config,/lib/rspec/,/lib/rspec-'
  end
end
