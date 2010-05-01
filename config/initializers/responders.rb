class ApplicationResponder < ActionController::Responder
  include Responders::FlashResponder
  include Responders::HttpCacheResponder
  
  def default_action
    @action ||= ACTIONS_FOR_VERBS[request.request_method_symbol]
  end
  
end

require 'inherited_resources/responder'
class InheritedResources::Responder
  def default_action
    @action ||= ACTIONS_FOR_VERBS[request.request_method_symbol]
  end
end

ApplicationController.respond_to :html
ApplicationController.responder = ApplicationResponder
