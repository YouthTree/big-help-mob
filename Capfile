require 'rubygems'
require 'bundler/setup'
require 'youthtree-capistrano'

require 'youth_tree/recipes/passenger'

set :application,     "bighelpmob"
set :repository_name, "big-help-mob"
set :rvm_bin_path,    "/usr/local/bin"

set :bundle_without, [:development, :test, :test_mac]

# Env-specific configuration.
set(:using_monit) { stage == "production" }
set(:server_name) { stage == "production" ? "unicorn" : "passenger" }
set(:branch)      { stage == "production" ? "master"  : "develop" }

namespace :resque do

  task :start do
    if using_monit
      run "sudo monit start resque_worker_bhm"
    else
      bundle_exec "./script/resque start"
    end
  end

  task :restart do
    if using_monit
      run "sudo monit restart resque_worker_bhm"
    else
      bundle_exec "./script/resque restart"
    end
  end

  task :setup do
    bundle_exec 'ln -s "$(bundle show resque)/lib/resque/server/public" public/resque'
  end

end

# And hook it all into place.
after 'deploy:start',       'resque:start'
after 'deploy:restart',     'resque:restart'
after 'deploy:update_code', 'resque:setup'

namespace :sync do
  task :sanitize_local do
    system "bundle exec rake sync:sanitize"
  end
end

after 'sync:load_local_db',  'sync:sanitize_local'