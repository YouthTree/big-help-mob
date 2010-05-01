require 'resque/job_with_status'
require 'resque/server'
require 'resque/status_server'

Resque::Server.use Rack::Auth::Basic do |username, password|
  User.admin_as? username, password
end