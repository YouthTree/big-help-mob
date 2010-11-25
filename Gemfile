source 'http://rubygems.org'

def gh(user, repo)
  "git://github.com/#{user}/#{repo}.git"
end

# Rails!
gem 'rails', '= 3.0.1'
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
gem 'state_machine',    '>= 0.9.0', :git => gh('pluginaweek', 'state_machine')
gem 'pseudocephalopod', '>= 0.3.1'

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

gem 'SystemTimer'

# Javascript Stuff
gem 'therubyracer', :require => nil
gem 'barista',           '>= 0.5.0', :path => '/Users/sutto/Code/OSS/barista'
gem 'shuriken',          '>= 0.2.0'
gem 'youthtree-js',      '>= 0.2.0'

gem 'rfc-822'

# Background workers
gem 'resque', '>= 1.10'
gem 'resque-status', :require => 'resque/status'

# View / Rendering
gem 'haml',               '>= 3.0.13'
gem 'compass',            '>= 0.10.4'
gem 'compass-960-plugin', '>= 0.9.13', :require => nil
gem 'compass-colors',     '>= 0.3.1', :require => nil
gem 'fancy-buttons',      '>= 0.5.4', :require => nil

gem 'youthtree-settings'
gem 'youthtree-helpers'
gem 'youthtree-controller-ext'

# Auth
gem 'authlogic',     :git => gh('kurbmedia', 'authlogic')
gem 'authlogic_rpx', :git => gh('kuldarkrabbi', 'authlogic_rpx')
gem 'rpx_now'

gem 'awesome_print'

gem 'youthtree-capistrano', '>= 0.2.2', :require => nil
gem 'ydd', "~> 0.0.6", :require => nil

gem 'unicorn', :require => nil

gem 'campaigning'

group :development do
  gem 'rails3-generators'
  gem 'annotate', :git => 'git://github.com/miyucy/annotate_models.git', :require => nil
  gem 'ruby-debug', :require => nil
end

group :test, :development do
  gem 'rspec',       '>= 2.0.0.beta.22'
  gem 'rspec-rails', '>= 2.0.0.beta.22'
  gem 'machinist',   '>= 2.0.0.beta2', :require => nil
  gem 'forgery', :require => nil
  gem 'rcov'
end

group :test do
  gem 'ZenTest'
  gem 'remarkable', '>= 4.0.0.alpah4', :require => 'remarkable/core'
  gem 'remarkable_activerecord', '>= 4.0.0.alpah4', :require => 'remarkable/active_record'
  gem 'rr'
end

group :test_mac do
  gem 'autotest-growl'
  gem 'autotest-fsevent'
end

group :staging, :production do
  gem 'hoptoad_notifier'
end
