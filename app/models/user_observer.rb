class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    user.notify! :signup
    user.save_initial_mailing_list_subscriptions
  end
  
  def after_save(user)
    user.update_mailchimp_subscription
  end
  
end
