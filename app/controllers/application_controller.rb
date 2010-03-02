class ApplicationController < ActionController::Base
  protect_from_forgery

  include AuthlogicHelpers

  protected

  helper_method :can?
  def can?(action, object)
    logged_in? && current_user.can?(action, object)
  end

  def unauthorized!(message = nil)
    respond_to do |format|
      format.html do
        message = ["I'm sorry, you don't have the correct permissions to do that", message].compact.join(" - ")
        redirect_to :root, :alert => message
      end
      format.json { head :forbidden }
      format.xml  { head :forbidden }
    end
  end

end
