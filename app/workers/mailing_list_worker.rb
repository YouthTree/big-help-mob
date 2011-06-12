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
    log_info "Performing #{self.class.name} with at #{Time.now} with:"
    log_info "Subscriber details: #{subscriber_details.inspect}"
    log_info "Mailing lists:      #{mailing_list_ids.inspect}"
    CampaignMonitorWrapper.update_for_subscriber! @subscriber_details, @mailing_list_ids
    log_info "Subscription done."
  rescue RuntimeError => e
    log_error "Error managing subscriptions for #{@subscriber_details.inspect} - #{e.message} (#{e.class.name})"
  end



  def log_info(text)
    Rails.logger.info "Resque - #{self.class.name} - #{Time.now}: #{text.to_s}"
  end

  def log_error(text)
    Rails.logger.error "Resque - #{self.class.name} - #{Time.now}: #{text.to_s}"
  end

end