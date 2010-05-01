# Sends out bulk emails, using a dynamic scope
class IndividualUserMailer < BaseUserMailer
  
  def process_email(email)
    total         = email.user_count + 2
    offset        = 2
    at 0, total, "Preparing templates"
    text_template    = email.template_for_text_content
    html_template    = email.template_for_html_content
    subject_template = email.template_for_subject
    at 1, total, "Preparing templates"
    email.each_user do |user|
      send_mail! email.rendered_email_for(user), user.email
      at offset, total, "Sending email to #{user.email}"
      offset += 1
    end
    completed "All emails sent"
  end
  
end