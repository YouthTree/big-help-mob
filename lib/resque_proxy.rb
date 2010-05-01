class ResqueProxy
  
  def initialize(app)
    @app = Rack::URLMap.new("/" => app, "/admin/resque" => Resque::Server.new)
  end
  
  def call(env)
    @app.call env
  end
  
end