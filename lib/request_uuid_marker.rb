class RequestUUIDMarker < Rails::Subscriber
  
  cattr_accessor :uuid
  
  self.uuid ||= UUID.new
  
  def initialize(app)
    @app = app
  end
  
  def call(env)
    uuid = self.class.uuid.generate
    env['rack.log-marker.uuid'] = uuid
    before_dispatch uuid
    @app.call(env)
  ensure
    after_dispatch uuid
  end
  
  protected
  
  def before_dispatch(uuid)
    info "Before request with UUID: #{uuid}"
  end
  
  def after_dispatch(uuid)
    info "After request with UUID: #{uuid}"
  end
  
end