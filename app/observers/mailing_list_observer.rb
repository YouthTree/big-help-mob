class MailingListObserver < ActiveRecord::Observer
  
  observe :user
  
  def after_save(user)
    user.mailing_lists.save
  end
  
end
