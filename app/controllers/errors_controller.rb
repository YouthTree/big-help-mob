class ErrorsController < ApplicationController
  
  def catch_all
    render_error_page :not_found
  end
  
  def general_exception
    render_error_page :internal_server_error
  end
  
end
