class UserSession < Authlogic::Session::Base

  rpx_key YAML.load(Rails.root.join("config", "rpx.yml").read)["api_key"]

end