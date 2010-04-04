class ErrorsController < ApplicationController
  
  def not_found
    render_error_page :not_found
  end
  
  def general_exception
    render_error_page :internal_server_error
  end
  
  protected
  
  def on_error_page?
    true
  end
  
end
