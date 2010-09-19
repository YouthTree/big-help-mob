class ApplicationController < ActionController::Base
  
  self.responder = ApplicationResponder
  respond_to :html
  
  protect_from_forgery

  include TitleEstuary
  include ErrorPages
  include SslRequirement

  use_controller_exts :authlogic_helpers, :authorization_helpers,
                      :title_estuary, :ssl_requirement, :translation

  protected

  helper_method :on_error_page?

  def on_error_page?
    false
  end
  
  def require_valid_user
    if logged_in? && !current_user.valid?
      store_location
      redirect_to edit_user_path(:current), :alert => tf('profile.invalid')
      return false
    end
  end

end
