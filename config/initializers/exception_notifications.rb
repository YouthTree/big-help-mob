if Settings.exception_notifier?
  require 'exception_notifier'
  BigHelpMob::Application.config.middleware.use ExceptionNotifier,
      :email_prefix         => "[BigHelpMob] ",
      :sender_address       => %{"BHM Error Notifier" <noreply@bighelpmob.org>},
      :exception_recipients => Array(Settings.exception_notifier.recipients)
end
