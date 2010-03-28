module ErrorPages
  
  def self.included(parent)
    parent.class_eval do
      extend ClassMethods
      rescue_to_error_page! ActiveRecord::RecordNotFound,   :not_found
      rescue_to_error_page! ActionController::RoutingError, :not_found
    end
  end
  
  protected
  
  def render_error_page(name, status = name.to_sym)
    self.page_title = I18n.t(name.to_sym, :scope => [:error_pages, :title], :default => name.to_s.titleize)
    render :template => "error_pages/#{name}",
           :status   => status
  end
  
  module ClassMethods
    
    def rescue_to_error_page!(exception, name, status = name.to_sym)
      logger.debug "Rescue from: #{exception.inspect} - #{name.inspect}, #{status.inspect}"
      rescue_from(exception) do
        render_error_page name, status
      end
    end
    
  end
  
end