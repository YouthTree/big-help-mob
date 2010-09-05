module MailingListSubscribeable
  extend ActiveSupport::Concern
  
  included do
    if respond_to?(:after_save)
      after_save :persist_ml_subscriptions!, :if => :should_persist_ml_subscriptions?
    end
  end
  
  module ClassMethods
    
    def available_mailing_list_choices
      CampaignMonitorWrapper.list_options_for_select
    end
    
  end
  
  module InstanceMethods
  
    def needs_ml_subscriptions?
      true
    end
    
    def should_persist_ml_subscriptions?
      needs_ml_subscriptions? && mailing_list_choices_set?
    end
  
    # Hook for post-persistence
    def persisted_ml_subscriptions!
      @mailing_list_choices_set = false
      @mailing_list_choices     = []
    end
  
    def mailing_list_choices_set?
      defined?(@mailing_list_choices_set) && @mailing_list_choices_set
    end
  
    # Returns the selected mailing list choices
    def mailing_list_choices
      @mailing_list_choices ||= default_mailing_list_choices
    end
  
    def mailing_list_choices=(value)
      @mailing_list_choices_set = true
      if needs_ml_subscriptions?
        @mailing_list_choices = Array(value).reject(&:blank?)
      else
        @mailing_list_choices = nil
      end
    end
  
    def default_mailing_list_choices
      @mailing_list_choices_set = false
      needs_ml_subscriptions? ? ["default"] : []
    end
  
    def mailing_list_ids
      CampaignMonitorWrapper.expand_lists(mailing_list_choices)
    end
    
    def persist_ml_subscriptions!
      MailingListWorker.queue_for! subscriber
      persisted_ml_subscriptions!
    end
    
    def to_subscriber_details
      if !respond_to?(:email) || !respond_to?(:name)
        raise NotImplementedError, "please implement a custom to_subscriber_details method."
      else
        {
          :email => self.email,
          :name  => self.name
        }
      end
    end
  
  end
end