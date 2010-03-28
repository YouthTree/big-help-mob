Settings.mailer.tap do |s|
  ActionMailer::Base.default_url_options[:host] = s.host
  ActionMailer::Base.delivery_method            = s.delivery_method.to_sym
  ActionMailer::Base.smtp_settings              = s.smtp_settings     if s.smtp_settings?
  ActionMailer::Base.sendmail_settings          = s.sendmail_settings if s.sendmail_settings?
  ActionMailer::Base.default              :from => s.from
end