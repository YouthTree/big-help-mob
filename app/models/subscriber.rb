class Subscriber < ActiveRecord::Base
  include CollatableOptionMixin

  validates_presence_of   :email, :name
  validates_format_of     :email, :message => 'is not a valid email address', :with => RFC822::EMAIL, :allow_blank => true
  validates_uniqueness_of :email

  has_collatable_option :volunteering_history, 'user.volunteering_history'

  attr_accessible :name, :email, :volunteering_history_id

  after_create :subscribe!

  def to_subscriber_details
    {:name => name, :email => email}
  end

  # Adds a job to subscribe the user. Note that this needs to be refactored.
  def subscribe!
    CampaignMonitorWrapper.update_for_subscriber! self
  end

end
