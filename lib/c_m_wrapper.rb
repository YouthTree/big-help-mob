class CMWrapper
  
  @@config ||= nil
  
  class << self
    
    def local_id_to_name_mapping(ids)
      lists = config.list_mapping
      Array(ids).map { |id| lists[id] }
    end
    
    def config
      Settings.campaign_monitor
    end
    
    def hominid_instance
      @@__instance ||= begin
        api_key = config.api_key
        # Hominid::Base.new(:api_key => api_key) if api_key.present?
      end
    end
    
    # Returns an array of the lists a given email
    # address is subscribed to.
    def subscriptions_for_email(email)
    end
    
    # Returns the mailing lists a given user is
    # subscribed to
    def subscriptions_for_user(user)
      subscriptions_for_email user.email
    end
    
    # Returns a list of all lists that are available for subscription
    # Each list is in the format {:display_name => 'something', :id => 'something'}
    # else format
    def available_lists
    end
    
    # Returns all the lists a user can subscribe to.
    def available_lists_for_select
      available_lists.map { |list| [list[:display_name], list[:id]] }
    end
    
    # Marks a user as subscribing to a given list.
    # Returns true if it succeeds in subscribing, false otherwise.
    def subscribe_user!(user, list_id)
    end
    
    # Removes a user from a given list subscription,
    # returning false if it can't unsubscribe the email.
    def unsubscribe_user!(user, list_id)
    end
    
    # Updates the subscriptions for a user with the given email.
    def update_email!(from, to)
      return false if hominid_instance.blank? || to =~ /\@example\.com$/i
      # For each of the lists they're subscribed to,
      # We basically need to unsubscribe and resubscribe them.
      list_ids = subscriptions_for_email(from)
      true
    end
    
    def user_subscribed?(user, list_id)
      return false if hominid_instance.blank?
      subscriptions_for_user(user).include?(list_id)
    end
    
    protected
    
    def subscribed_from_email()
    end
    
  end
  
end