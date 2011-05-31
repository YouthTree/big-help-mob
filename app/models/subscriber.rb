class Subscriber < ActiveRecord::Base

  validates_presence_of   :email, :name
  validates_format_of     :email, :message => 'is not a valid email address', :with => RFC822::EMAIL, :allow_blank => true
  validates_uniqueness_of :email

  after_create :subscribe!

  def to_subscriber_details
    {:name => name, :email => email}
  end

  # Adds a job to subscribe the user. Note that this needs to be refactored.
  def subscribe!
    CampaignMonitorWrapper.update_for_subscriber! self
  end

end
