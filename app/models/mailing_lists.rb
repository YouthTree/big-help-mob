class MailingLists
  extend  ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Dirty
  
  define_attribute_methods [:ids]
  
  def self.subscription_manager
    HominidWrapper
  end
  
  def self.i18n_scope
    :mailing_lists
  end
  
  def initialize(user)
    super()
    @user = user
  end
  
  def names
    self.class.subscription_manager.local_id_to_name_mapping(ids)
  end
  
  def ids
    @ids ||= begin
      if @user.email.blank?
        []
      elsif @user.new_record?
        default_subscriptions
      else
        read_stored_ids
      end
    end
  end
  
  def ids=(value)
    normalized_values = normalize_ids(value)
    return if normalized_values == ids
    # Otherwise, set the attributes 
    ids_will_change!
    @names = nil
    @ids   = normalized_values
  end
  
  def save
    if valid?
      @previously_changed = changes
      update_email_address!  if @user.email_changed?
      persist_subscriptions! if ids_changed?
      @changed_attributes = {}
      true
    end
  end
  
  def clear
    self.ids = nil
    save
  end
  
  def has_email?
    @user.email.present?
  end
  
  def new_record?
    @user.new_record?
  end
  
  def self.for_select
    @lists_for_select ||= begin
      self.class.subscription_manager.available_lists.map do |result|
        [result[:display_name], result[:id]]
      end
    end
  end
  
  protected
  
  def logger
    Rails.logger
  end
  
  def default_subscriptions
    []
  end
  
  def normalize_ids(ids)
    Array(ids).reject { |v| v.blank? }
  end
  
  def read_stored_ids
    self.class.subscription_manager.subscriptions_for_user(@user) & self.class.subscription_manager.available_lists.map { |l| l[:id] }
  end
  
  def update_email_address!
    from, to = @user.email_was, @user.email
    return if from == true
    if to.blank?
      read_stored_ids.each { |id| self.class.subscription_manager.unsubscribe_user!(@user, id) }
    elsif from.present?
      self.class.subscription_manager.update_email!(from, to)
    end
  end
  
  def persist_subscriptions!
    original_ids  = read_stored_ids
    new_ids = self.ids
    ids_to_remove, ids_to_add = (original_ids - new_ids), (new_ids - original_ids)
    ids_to_remove.each { |id| self.class.subscription_manager.unsubscribe_user!(@user, id) }
    ids_to_add.each    { |id| self.class.subscription_manager.subscribe_user!(@user, id) }
  end
  
end