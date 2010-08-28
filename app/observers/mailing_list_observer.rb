class MailingListObserver < ActiveRecord::Observer
  
  observe :user
  
  def after_create(user)
    update_subscriptions_for user if user.using_password?
  end
  
  def after_update(user)
    update_subscriptions_for user
  end
  
  def update_subscriptions_for(user)
    unless user.completed_mailing_list_subscriptions?
      MailingListWorker.queue_for! user
      user.mailing_list_ids = nil
      user.completed_mailing_list_subscriptions = true
      User.where(:id => user.id).update_all :completed_mailing_list_subscriptions => true
    end
  end
  
end
