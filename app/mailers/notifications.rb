class Notifications < ActionMailer::Base
  include ActionMailerNicerI18nSubjects
  CORRECTED_ORDER = [:text, :html]

  def signup(user)
    @user = user
    subject_vars :user_name => user.to_s
    mail         :to        => user.email
  end

  def joined_mission(user, mission_participation)
    @mission               = mission_participation.mission
    @mission_participation = mission_participation
    @user                  = user
    subject_vars :mission_name => @mission.name
    mail         :to           => user.email
  end

  def mission_signup_incomplete(user)
    mail :to => user.email
  end

  def notice(email)
    mail :to => Settings.mailer.from.gsub("@", "+outgoing@"), :bcc => email.emails, :subject => email.subject do |r|
      r.html { render :text => email.html_content } if email.html_content.present?
      r.text { render :text => email.text_content } if email.text_content.present?
    end
  end
  
  def password_reset(user)
    @user = user
    mail :to => user.email
  end
  
  def mission_role_approved(user, mission_participation)
    @user                  = user
    @mission_participation = mission_participation
    subject_vars :mission_name => mission_participation.mission.name, :role_name => mission_participation.role_name.humanize
    mail :to => user.email do |r|
      dynamic_templates! r, mission_participation.mission, :text, :html,
                         "role-approved.#{mission_participation.role_name.dasherize}",
                         :user => user, :mission_participation => mission_participation,
                         :mission => mission_participation.mission, :role => mission_participation.role,
                         :pickup => mission_participation.pickup
    end
  end
  
  protected
  
  def dynamic_templates!(r, parent, *formats)
    scope = formats.extract_options!
    key = formats.pop
    formats.sort_by { |f| CORRECTED_ORDER.index(f.to_sym) }.each do |format|
      format = format.to_s
      body = DynamicTemplate.get(parent, format, "notifications.#{key}", scope)
      if body.present?
        r.send(format) { render :text => body }
      else
        r.send(format)
      end
    end
    
  end
  
end
