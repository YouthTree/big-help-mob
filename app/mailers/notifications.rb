class Notifications < ActionMailer::Base
  include ActionMailerNicerI18nSubjects

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

  def notice
  end
  
  def password_reset(user)
    @user = user
    mail :to => user.email
  end
  
  def mission_role_approved(user, mission_participation)
    @user                  = user
    @mission_participation = mission_participation
    mail :to => user.email do |r|
      dynamic_templates! r, mission_participation.mission, :html, "role-approved.#{mission.role_name.to_s.dasherize}",
                         :user => user, :mission_participation => mission_participation
    end
  end
  
  protected
  
  def dynamic_templates!(r, parent, key, *formats)
    scope = formats.extract_options!
    formats.each do |format|
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
