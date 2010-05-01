class BaseUserMailer < Resque::JobWithStatus
  
  def self.queue
    :user_mailers
  end
  
  def self.queue_for!(email)
    Rails.logger.debug "Enqueueing #{name} for email"
    create :email => email.to_json if email.present?
  end
  
  def perform
    return if options['email'].blank?
    email = Email.from_json(options['email'])
    process_email email if email.valid?
  end
  
  def process_email(email)
    raise NotImplementedError
  end
  
  protected
  
  def send_mail!(email, users)
    Rails.logger.info Notifications.notice(email, users).deliver
  end
  
end