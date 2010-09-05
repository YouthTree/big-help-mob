class MailingListWorker

  def self.queue; 'mailing-lists'; end
  
  def initialize(subscriber_details, mailing_list_ids)
    @subscriber_details = subscriber_details
    @mailing_list_ids   = mailing_list_ids
  end
  
  def self.queue_for!(user)
    debugger
    return if !subscriber.mailing_list_ids.present?
    debugger
    details, list_ids = subscriber.to_subscriber_details, subscriber.mailing_list_ids
    Resque.enqueue self.class, details, list_ids
  end
  
  def self.perform(subscriber_details, mailing_list_ids)
    new(subscriber_details, mailing_list_ids).subscribe!
  end
  
  def subscribe!
    CampaignMonitorWrapper.update_subscriptions_for_subscriber! subscriber_details, @mailing_list_ids
  end
  
end