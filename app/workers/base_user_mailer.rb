class BaseUserMailer < Resque::JobWithStatus

  def self.queue
    :user_mailers
  end

  def self.queue_for!(email)
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

  def log_info(text)
    Rails.logger.info "Resque - #{self.class.name} - #{Time.now}: #{text.to_s}"
  end

  def send_mail!(email, users)
    log_info "Sending email with subject '#{email.subject}' to #{users.size}"
    log_info "Destination users: #{Array.wrap(users).to_sentence}"
    Rails.logger.info Notifications.notice(email, users).deliver
    log_info "Email sent."
  end

end