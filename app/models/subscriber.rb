# Virtual model to handle subscriptions to CM.
class Subscriber
  extend ActiveModel::Naming  
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations

  attr_accessor :name, :email, :list_ids
    
  validates_presence_of :email,    :message => 'must be filled in to continue.'
  validates_presence_of :list_ids, :message => 'you need to choose at least 1 list to subscribe to.'
  validates_format_of   :email, :with => RFC822::EMAIL, :message => 'is not a valid email address.'
  
  def initialize(values = {})
    @persisted = false
    values = {} unless values.is_a?(Hash)
    values = values.symbolize_keys
    [:name, :email, :list_ids].each do |k|
      send"#{k}=", values[k]
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
    @list_ids = (Array(value).reject(&:blank?) & CampaignMonitorWrapper.available_list_ids)
  end
  
  def persist!
    @persisted = true
  end
  
  # Adds a job to subscribe the user.
  def subscribe!
    # TODO: Implement
  end
  
end