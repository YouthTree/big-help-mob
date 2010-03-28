class ErrorsController < ApplicationController
  
  def catch_all
    render_error_page :not_found
  end
  
end
