class CampaignMonitorWrapper
  
  @@config ||= nil
  
  class << self
    
    def for_select
      available_lists.map { |k, v| [v, k] }
    end
    
    def available_lists
      Settings.campaign_monitor.lists.to_hash.stringify_keys
    end
    
    def available_list_names
      available_lists.values
    end
    
    def available_list_ids
      available_lists.keys
    end
    
    def update_subscriptions!(user, lists)
      return false unless has_campaign_monitor?
      cm_user = cm_user_for user
      lists = Array(lists.flatten).reject { |l| l.blank? } & available_list_ids
      lists.each { |list| subscribe! cm_user, list }
      true
    end
    
    def subscribe!(user, list)
      return false unless has_campaign_monitor?
      user.add_and_resubscribe! list if user.present?
      true
    end
    
    def cm_user_for(user)
      name = user.full_name
      name = user.name if name.blank?
      Campaigning::Subscriber.new(user.email, name)
    end
    
    def has_campaign_monitor?
      defined?(Campaigning) && defined?(CAMPAIGN_MONITOR_API_KEY) && CAMPAIGN_MONITOR_API_KEY.present?
    end
    
    def configure!
      if Settings.campaign_monitor.api_key?
        require 'campaigning'
        Object.const_set :CAMPAIGN_MONITOR_API_KEY, Settings.campaign_monitor.api_key
      end
    end
    
  end
  
end