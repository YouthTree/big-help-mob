source 'http://gemcutter.org'

gem "rails", "3.0.0.beta"

gem "haml"
gem "mysql"

# mailing list
gem "hominid"

# geo-awareness stuff and helpers to present addresses more cleanly
gem "addresslogic"
gem "geokit"

# display helpers
gem "formtastic"

gem "compass", ">= 0.10.0.rc1"
gem "compass-960-plugin"

# authentication
gem "rpx_now"

git "git://github.com/indirect/rails3-generators.git"
gem "rails3-generators"

gem "forgery"

# Enabled mongrel in development for script/server
gem "mongrel", :group => "development", :require => nil

group :test do
  git "git://github.com/adamhunter/shoulda.git", :branch => "rails3"
  gem "redgreen", :require => nil
  gem "shoulda",  :require => nil
end
