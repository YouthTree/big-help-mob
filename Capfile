require 'rubygems'
require 'bundler/setup'
require 'youthtree-capistrano'

set :application,     "bighelpmob"
set :repository_name, "big-help-mob"

# Use git-flow based branches for deployment.
set :branch do
  stage == "production" ? "master" : "develop"
end

namespace :resque do
  task :run do
    bundle_exec "./script/resque QUEUE=*"
  end
end

after 'deploy:cold', 'resque:run'
after 'deploy',      'resque:run'

namespace :sync do
  task :sanitize_local do
    system "bundle exec rake sync:sanitize"
  end
end

after 'sync:load_local_db',  'sync:sanitize_local'