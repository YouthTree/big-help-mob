class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include AuthlogicHelpers
  include AuthorizationHelpers
  include TitleEstuary
  include TitleEstuaryExt
  
  protected
  
  def tf(key)
    I18n.t(key.to_sym, :scope => :flash)
  end

end
