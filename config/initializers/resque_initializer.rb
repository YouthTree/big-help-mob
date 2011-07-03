require 'resque/job_with_status'
require 'resque/server'
require 'resque/status_server'
Resque.redis.namespace = "resque:bhm:#{Rails.env}"

begin
  # this will fail because it has some bad inclusion code
  require 'authlogic/controller_adapters/sinatra_adapter'
rescue NoMethodError
end

module Resque
  class Server

    configure do
      enable :sessions
    end

    use Rack::Session::Cookie, :key => Settings.fetch(:session_key, 'bhm-session'), :secret => Settings.secret_key

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

    before do
      controller = Authlogic::ControllerAdapters::SinatraAdapter::Controller.new(request, response)
      Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::SinatraAdapter::Adapter.new(controller)
      redirect '/' unless current_user && current_user.admin?
    end

  end
end