# Sends out emails using bcc and static content. No dynamic processing is done on outgoing emails.
class BulkUserMailer < BaseUserMailer

  def process_email(email)
    at 0, 1, "About to send emails"
    send_mail! email, email.emails
    completed "Emails sent"
  end

end