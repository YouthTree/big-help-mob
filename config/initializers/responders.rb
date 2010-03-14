class ApplicationResponder < ActionController::Responder
  include Responders::FlashResponder
  include Responders::HttpCacheResponder
end

ApplicationController.respond_to :html
ApplicationController.responder = ApplicationResponder
