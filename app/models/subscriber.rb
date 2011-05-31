class Subscriber < ActiveRecord::Base
  include CollatableOptionMixin
  include MailingListSubscribeable

  validates_presence_of   :email, :name
  validates_format_of     :email, :message => 'is not a valid email address', :with => RFC822::EMAIL, :allow_blank => true
  validates_uniqueness_of :email

  has_collatable_option :volunteering_history, 'user.volunteering_history'

  attr_accessible :name, :email, :volunteering_history_id

  before_create :prepare_subscribeable_settings

  # Always return the default mailing list as the users choice.
  def mailing_list_choices
    %w(default)
  end

  private

  def prepare_subscribeable_settings
    @mailing_list_choices_set = true
  end

end
