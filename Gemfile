source 'http://gemcutter.org'

# TODO: Uncomment when submodules stuff is fixed.
# git "git://github.com/rlivsey/will_paginate.git", :ref => "rails3"
git "git://github.com/nono/acts_as_list.git",     :ref => "rails3"

# General WIP Fixes.
git "git://github.com/Sutto/exception_notification.git"
git "git://github.com/Sutto/validation_reflection.git"
git "git://github.com/justinfrench/formtastic.git", :ref => "rails3"
git "git://github.com/railsjedi/jammit.git"

# Rails!
gem "rails", "= 3.0.0.beta3"

# Misc
gem "mysql",   ">= 2.8.1"
gem "forgery", ">= 0.3.4"

# mailing list
gem "hominid", ">= 2.1.1"

# Geoawareness and mapping stuff.
gem "addresslogic",    ">= 1.2.1"
gem "geokit",          ">= 1.5.0"
gem "bhm-google-maps", ">= 0.1.0"

# Display Helpers
gem "formtastic",            "= 0.9.8"
gem "validation_reflection", ">= 0.3.6"
gem "title_estuary",         ">= 1.2.0"

# View / Rendering
gem "haml", "= 3.0.0.beta.3"
gem "compass",            ">= 0.10.0.rc3"
gem "compass-960-plugin", ">= 0.9.13"
gem "compass-colors",     ">= 0.3.1"
gem "fancy-buttons",      ">= 0.5.1"

# Authentication
gem "rpx_now"

# Mainly Admin Area Stuff.
gem "inherited_resources", ">= 1.1.2"
gem "responders",          ">= 0.6.0"
gem "show_for",            ">= 0.2.1"
gem "ruby-googlechart",    ">= 0.6.4", :require => "google_chart"

# General Code Stuff
gem "will_paginate",       ">= 3.0.pre"
gem "state_machine",       ">= 0.9.0"
gem "pseudocephalopod", ">= 0.2.1"
gem "acts_as_list",        ">= 0.2.0"

# Helpers etc.
gem "jammit",              ">= 0.5.0"
gem "msales-carmen",       ">= 0.1.4", :require => ["carmen", "carmen/action_view_helpers"]

# Misc. Libraries
gem "exception_notifier", :require => nil
gem "liquid"
gem "fastercsv"
gem "stringex"
gem "uuid"
gem "mail_form", ">= 1.2.1"
gem "sitemap_generator"


group :development do
  gem "yard",      :require => nil
  gem "bluecloth", :require => nil
  gem "rails3-generators"
end

group :test do
  git "git://github.com/adamhunter/shoulda.git", :ref => "rails3"
  gem "redgreen", :require => nil
  gem "shoulda",  ">= 3.0.pre", :require => nil
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
end