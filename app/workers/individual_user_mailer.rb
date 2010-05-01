# Sends out bulk emails, using a dynamic scope
class IndividualUserMailer < BaseUserMailer
  
  class BlankRenderer
    def render(scope = {}); ""; end
  end
  
  def process_email(email)
    total         = email.user_count + 2
    offset        = 2
    at 0, total, "Preparing templates"
    text_template    = liquid_renderer_section(email.text_content)
    html_template    = liquid_renderer_section(email.html_content)
    subject_template = liquid_renderer_section(email.subject)
    at 1, total, "Preparing templates"
    email.each_user_with_scope do |user, scope|
      scoped_email              = email.dup
      scoped_email.subject      = subject_template.render(scope)
      scoped_email.text_content = text_template.render(scope)
      scoped_email.html_content = html_template.render(scope)
      send_mail! scoped_email, user.email
      at offset, total, "Sending email to #{user.email}"
      offset += 1
    end
    completed "All emails sent"
  end
  
  def liquid_renderer_section(content)
    if content.blank?
      BlankRenderer.new
    else
      Liquid::Template.parse(content)
    end
  end
  
end