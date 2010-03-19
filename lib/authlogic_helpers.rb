module AuthlogicHelpers

  def self.included(parent)
    parent.class_eval do
      helper_method :current_user, :current_user_session, :logged_in?
    end
  end

  protected

  def logged_in?
    current_user.present?
  end

  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.record
  end

  def require_user
    unless logged_in?
      store_location
      redirect_to sign_in_path, :notice => "To view this page, you must first log in."
      return false
    end
  end

  def require_no_user
    if logged_in?
      store_location
      redirect_to users_path(:current), :notice => "You must be logged out to access this page"
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri if request.get?
  end

  def redirect_back_or_default(default, options = {})
    redirect_to(session[:return_to] || default, options)
    session[:return_to] = nil
  end

end