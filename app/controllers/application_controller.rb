class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include AuthlogicHelpers
  include AuthorizationHelpers
  include TitleEstuary
  include TitleEstuaryExt

end
