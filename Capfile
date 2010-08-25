require 'rubygems'
require 'bundler/setup'
require 'youthtree-capistrano'

set :application,     "bighelpmob"
set :repository_name, "big-help-mob"

namespace :resque do
  task :run do
    bundle_exec "./script/resque QUEUE=*"
  end
end

after 'deploy:cold', 'resque:start'
after 'deploy',      'resque:start'