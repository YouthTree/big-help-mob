# Virtual model to handle subscriptions to CM.
class Subscriber
  extend  ActiveModel::Naming
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  include ActiveModel::Conversion

  def self.to_key
    :subscriber
  end

  attr_accessor :name, :email, :list_ids

  validates_presence_of :email, :name, :message => 'must be filled in to continue'
  validates_presence_of :list_ids,     :message => 'must contain at least one valid mailing list choice'
  validates_format_of   :email,        :message => 'is not a valid email address', :with => RFC822::EMAIL, :allow_blank => true

  def self.list_options
    CampaignMonitorWrapper.list_options_for_select
  end

  def initialize(values = {})
    @persisted = false
    values = {} unless values.is_a?(Hash)
    values = values.symbolize_keys
    [:name, :email, :list_ids].each do |k|
      send "#{k}=", values[k]
    end
  end

  def persisted?
    @persisted
  end

  def save
    if valid? && !persisted?
      subscribe!
      persist!
    end
  end

  def list_ids
    @list_ids ||= []
  end

  def list_ids=(value)
    @list_ids = (Array(value).reject(&:blank?) & self.class.list_options.values)
  end

  def persist!
    @persisted = true
  end

  def to_subscriber_details
    {:name => name, :email => email}
  end

  # Adds a job to subscribe the user.
  def subscribe!
    expanded_list_ids = CampaignMonitorWrapper.expand_lists(list_ids)
    CampaignMonitorWrapper.update_for_subscriber! self, expanded_list_ids
  end

end
