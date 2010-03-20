class HominidWrapper
  
  @@config ||= nil
  
  class << self
    
    def local_id_to_name_mapping(ids)
      lists = config[:list_mapping]
      Array(ids).map { |id| lists[id] }
    end
    
    def config_from_file
      hominid_conf = YAML.load(Rails.root.join("config", "hominid.yml").read) rescue {}
      (hominid_conf["default"] || {}).merge(hominid_conf[Rails.env] || {}).symbolize_keys
    end
    
    def config
      @@config ||= config_from_file
    end
    
    def hominid_instance
      @@__instance ||= begin
        api_key = config[:api_key]
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
    
    def update_user_email(user)
      return false if hominid_instance.blank?
      old_email, new_email = user.email_was, user.email
      list_ids = subscriptions_for_email(old_email)
      if list_ids.present?
        list_ids.each do |list_id|
          hominid_instance.update_member(list_id, old_email, {:EMAIL => new_email})
        end
      end
      true
    end
    
    def update_user_subscriptions(user, subscription_ids)
      return false if hominid_instance.blank?
      user_lists = subscriptions_for_user(user)
      available_list_ids = available_lists.map { |l| l[:id] }
      subscribed_to_ids = (available_list_ids & subscription_ids)
      unsubscribe_from_ids = available_list_ids - subscription_ids
      unsubscribe_from_ids.each { |list_id| unsubscribe_user!(user, list_id) }
      subscribed_to_ids.each do |list_id|
        subscribe_user!(user, list_id) unless user_lists.include?(list_id)
      end
      return true
    end
    
    def available_lists
      return [] if hominid_instance.blank?
      mapping = config[:list_mapping]
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
    
    def user_subscribed?(user, list_id)
      return false if hominid_instance.blank?
      subscriptions_for_user(user).include?(list_id)
    end
    
  end
  
end