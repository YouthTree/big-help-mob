class HominidWrapper
  
  @@config ||= nil
  
  class << self
    
    def local_id_to_name_mapping(ids)
      lists = config.list_mapping
      Array(ids).map { |id| lists[id] }
    end
    
    def config
      Settings.hominid
    end
    
    def hominid_instance
      @@__instance ||= begin
        api_key = config.api_key
        Hominid::Base.new(:api_key => api_key) if api_key.present?
      end
    end
    
    def subscriptions_for_email(email)
      return [] if hominid_instance.blank?
      hominid_instance.find_list_ids_by_email(email)
    rescue Hominid::ListError
      []
    end
    
    def subscriptions_for_user(user)
      subscriptions_for_email user.email
    end
    
    def available_lists
      return [] if hominid_instance.blank?
      mapping = config.list_mapping.to_hash.stringify_keys
      mapping_ids = mapping.keys
      hominid_instance.lists.select { |l| mapping_ids.include?(l["id"]) }.map do |l|
        l.merge("display_name" => mapping[l["id"]]).symbolize_keys
      end
    end
    
    def available_lists_for_select
      available_lists.map { |list| [list[:display_name], list[:id]] }
    end
    
    def subscribe_user!(user, list_id)
      return false if hominid_instance.blank?
      return true if user_subscribed?(user, list_id)
      user_data = {}
      user_data[:FNAME] = user.first_name if user.first_name.present?
      user_data[:LNAME] = user.last_name  if user.last_name.present?
      hominid_instance.subscribe(list_id, user.email, user_data)
      return true
    end
    
    def unsubscribe_user!(user, list_id)
      return false if hominid_instance.blank?
      hominid_instance.unsubscribe(list_id, user.email) if user_subscribed?(user, list_id)
      return true
    end
    
    def update_email!(from, to)
      return false if hominid_instance.blank? || to =~ /\@example\.com$/i
      list_ids = subscriptions_for_email(from)
      Array(list_ids).each do |id|
        hominid_instance.update_member(id, from, :EMAIL => to)
      end
      true
    end
    
    def user_subscribed?(user, list_id)
      return false if hominid_instance.blank?
      subscriptions_for_user(user).include?(list_id)
    end
    
  end
  
end