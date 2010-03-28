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
  
end
