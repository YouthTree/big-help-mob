# For the moment, disable hoptoad.
# if Settings.hoptoad.api_key?
#   HoptoadNotifier.configure { |c| c.api_key = Settings.hoptoad.api_key }
# end

if Settings.exception_notifier?
  require 'exception_notifier'
  Bighelpmob::Application.config.middleware.use ExceptionNotifier,
      :email_prefix         => "[BigHelpMob] ",
      :sender_address       => %{"BHM Error Notifier" <noreply@bighelpmob.org>},
      :exception_recipients => Array(Settings.exception_notifier.recipients)
end