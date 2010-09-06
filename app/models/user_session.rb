class UserSession < Authlogic::Session::Base

  rpx_key Settings.rpx.api_key
  
  find_by_login_method :find_by_email_or_login

end