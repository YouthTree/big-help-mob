class UserSession < Authlogic::Session::Base

  rpx_key Settings.rpx.api_key

end