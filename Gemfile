source 'http://gemcutter.org'

git "git://github.com/rlivsey/will_paginate.git", :ref => "rails3"
git "git://github.com/nono/acts_as_list.git",     :ref => "rails3"

# General WIP Fixes.
git "git://github.com/Sutto/exception_notification.git"
git "git://github.com/Sutto/validation_reflection.git"
git "git://github.com/justinfrench/formtastic.git", :ref => "rails3"
git "git://github.com/railsjedi/jammit.git"

gem "rails", "= 3.0.0.beta2"

# Misc
gem "haml"
gem "mysql"
gem "forgery", ">= 0.3.4"

# mailing list
gem "hominid"

# geo-awareness stuff and helpers to present addresses more cleanly
gem "addresslogic"
gem "geokit"

# display helpers
gem "formtastic", "= 0.9.8"
gem "validation_reflection"

# Sass Awesome Sauce
gem "compass", ">= 0.10.0.rc1"
gem "compass-960-plugin"
gem "compass-colors"
gem "fancy-buttons"

# authentication
gem "rpx_now"

# Mainly Admin Area Stuff.
gem "inherited_resources", ">= 1.1.2"
gem "responders",          ">= 0.6.0"
gem "show_for",            ">= 0.2.1"

gem "will_paginate",       ">= 3.0.pre"
gem "state_machine"
gem "title_estuary"
gem "acts_as_list"
gem "mail_form"
gem "jammit"

gem "ruby-googlechart", :require => "google_chart"
gem "msales-carmen",    :require => ["carmen", "carmen/action_view_helpers"]

gem "exception_notifier", :require => nil

gem "liquid"

gem "fastercsv"

gem "stringex"

gem "uuid"

gem "sitemap_generator"

group :production do
  gem "unicorn", :require => nil
end

group :development do
  gem "mongrel",   :require => nil
  gem "yard",      :require => nil
  gem "bluecloth", :require => nil
  gem "rails3-generators"
end

group :test do
  git "git://github.com/adamhunter/shoulda.git", :ref => "rails3"
  gem "redgreen", :require => nil
  gem "shoulda",  ">= 3.0.pre", :require => nil
end