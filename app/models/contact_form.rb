class ContactForm < MailForm::Base
  
  attribute :name,     :validate => true
  attribute :nickname, :captcha => true
  attribute :email,    :validate => /[^@]+@[^\.]+\.[\w\.\-]+/
  attribute :message,  :validate => true
  
  def headers
    return :subject => ::I18n.t(:subject, :scope => [:actionmailer, :contact_form]),
           :from    => "#{name} <#{email}>",
           :to      => Settings.mailer.contact_email
  end
  
  def persisted?
    false
  end

end