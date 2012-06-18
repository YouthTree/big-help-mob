source 'http://rubygems.org'

def gh(user, repo)
  "git://github.com/#{user}/#{repo}.git"
end

# Rails!
gem 'rake', '~> 0.8.0'
gem 'rails', '= 3.0.7'
gem 'pg'
gem 'json'

# Geoawareness and mapping stuff.
gem 'addresslogic',    '>= 1.2.1'
gem 'geokit',          '>= 1.5.0'
gem 'bhm-google-maps', '~> 0.2.0'

# Display Helpers
gem 'formtastic',            '>= 1.1.0'
gem 'validation_reflection', '>= 1.0.0.rc.1'
gem 'title_estuary',         '>= 1.2.0'

# Mainly Admin Area Stuff.
gem 'inherited_resources'
gem 'responders'
gem 'show_for'

# General Code Stuff
gem 'will_paginate',    '>= 3.0.pre2', :git => gh('mislav', 'will_paginate'), :ref => 'rails3'
gem 'state_machine',    '~> 1.0.0'
gem 'slugged',          '>= 0.3.1'

# Helpers etc.
gem 'jammit',              '>= 0.5.0'
gem 'msales-carmen',       '>= 0.1.4', :require => ['carmen', 'carmen/action_view_helpers']

# Miscellaneous
gem 'liquid'
gem 'fastercsv' if RUBY_VERSION < '1.9'
gem 'uuid'
gem 'stringex'
gem 'mail_form', '>= 1.2.1'
gem 'sitemap_generator'
gem 'flickraw'
gem 'ruby-googlechart',    '>= 0.6.4', :require => 'google_chart'
gem 'zipstream'

gem 'SystemTimer'

# Javascript Stuff
gem 'therubyracer',      :require => nil
gem 'barista',           '~> 1.2'
gem 'shuriken',          '>= 0.2.0'
gem 'youthtree-js',      '>= 0.3.0'

gem 'rfc-822'

# Background workers
gem 'resque', '>= 1.10'
gem 'resque-status', :require => 'resque/status'
gem 'daemon-spawn', :require => nil

# View / Rendering
gem 'haml',               '>= 3.0.13'
gem 'haml-rails'
gem 'compass',            '~> 0.11.0'
gem 'compass-960-plugin', '>= 0.9.13', :require => nil
gem 'compass-colors',     '>= 0.3.1', :require => nil
gem 'fancy-buttons',      '>= 0.5.4', :require => nil

gem 'youthtree-settings'
gem 'youthtree-helpers'
gem 'youthtree-controller-ext', '>= 0.1.2'

# Auth
gem 'authlogic',     '~> 3.0.0'
gem 'authlogic_rpx', '~> 1.2.0', :git => 'git://github.com/YouthTree/authlogic_rpx.git'
gem 'rpx_now'

gem 'awesome_print', '0.2.1', :require => nil

gem 'youthtree-capistrano', '>= 0.2.2', :require => nil
gem 'ydd', "~> 0.0.6", :require => nil

gem 'unicorn', :require => nil

gem 'campaigning'

gem 'meta_search'

gem "rails-erd"

group :development do
  gem 'rails3-generators'
  gem 'annotate', :git => gh('miyucy', 'annotate_models'), :require => nil
  gem 'ruby-debug', :require => nil
end

group :test, :development do
  gem 'rspec',       '~> 2.1'
  gem 'rspec-rails', '~> 2.1'
  gem 'machinist',   '>= 2.0.0.beta2', :require => nil
  gem 'forgery', :require => nil
  gem 'rcov'
  gem 'guard', :require => nil
  gem 'guard-rspec', :require => nil
end

group :test do
  gem 'ZenTest'
  gem 'remarkable',              '>= 4.0.0.alpha4', :require => 'remarkable/core'
  gem 'remarkable_activerecord', '>= 4.0.0.alpha4', :require => 'remarkable/active_record'
  gem 'rr'
  gem 'ci_reporter', '~> 1.6.3', :require => nil
end

group :test_mac do
  gem 'autotest-growl'
  gem 'autotest-fsevent'
end

group :staging, :production do
  gem 'hoptoad_notifier'
end

group :test_mac do
  # gem 'rb-fsevent', :require => false
  # gem 'growl', :require => false
end