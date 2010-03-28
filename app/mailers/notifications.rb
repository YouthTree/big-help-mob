class Notifications < ActionMailer::Base
  include ActionMailerNicerI18nSubjects

  def signup(user)
    @user = user
    subject_vars :user_name => user.to_s
    mail         :to        => user.email
  end

  def joined_mission(user)
    mail :to => "to@example.org"
  end

  def mission_signup_incomplete(user)
    mail :to => "to@example.org"
  end

  def notice
    mail :to => "to@example.org"
  end
  
  def password_reset(user)
    mail :to => "to@example.org"
  end
  
end
