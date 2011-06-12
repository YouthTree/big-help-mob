class MailingListWorker

  def self.queue; 'mailing-lists'; end

  def initialize(subscriber_details, mailing_list_ids)
    @subscriber_details = subscriber_details
    @mailing_list_ids   = mailing_list_ids
  end

  def self.queue_for!(subscriber)
    return if !subscriber.mailing_list_ids.present?
    details, list_ids = subscriber.to_subscriber_details, subscriber.mailing_list_ids
    QueueManager.enqueue self, details, list_ids
  end

  def self.perform(subscriber_details, mailing_list_ids)
    new(subscriber_details, mailing_list_ids).subscribe!
  end

  def subscribe!
    CampaignMonitorWrapper.update_for_subscriber! @subscriber_details, @mailing_list_ids
  rescue RuntimeError => e
    Rails.logger.error "Error managing subscriptions for #{@subscriber_details.inspect} - #{e.message}"
  end

end