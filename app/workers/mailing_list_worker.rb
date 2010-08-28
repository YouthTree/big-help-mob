class MailingListWorker

  def self.queue; 'mailing-lists'; end
  
  def initialize(user_id, mailing_list_ids)
    @user_id          = user_id
    @mailing_list_ids = mailing_list_ids
  end
  
  def self.queue_for!(user)
    if user.mailing_list_ids.present?
      Resque.enqueue user.id, user.mailing_list_ids
    end
  end
  
  def self.perform(user_id, mailing_list_ids)
    new(user_id, mailing_list_ids).subscribe!
  end
  
  def subscribe!
    CampaignMonitorWrapper.update_subscriptions_for_user! user, @mailing_list_ids
  rescue ActiveRecord::RecordNotFound
  end
  
  protected
  
  def user
    @user ||= User.find(@user_id)
  end
  
end