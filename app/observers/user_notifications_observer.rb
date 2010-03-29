class UserNotificationsObserver < ActiveRecord::Observer
  
  observe :user
  
  def after_create(user)
    user.notify! :signup
  end
  
end
