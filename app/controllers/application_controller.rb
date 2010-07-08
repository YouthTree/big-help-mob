class ApplicationController < ActionController::Base
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

end
