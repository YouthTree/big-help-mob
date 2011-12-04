# Sends out bulk emails, using a dynamic scope
class IndividualUserMailer < BaseUserMailer
  
  def process_email(email)
    total         = email.user_count + 1
    offset        = 1
    at 0, total, "Preparing templates"
    email.each_user do |user|
      next if user.email.blank?
      send_mail! email.rendered_email_for(user), [user.email]
      at offset, total, "Sending email to #{user.email}"
      offset += 1
    end
    completed "All emails sent"
  end
  
end