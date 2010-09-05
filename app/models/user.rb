class User < ActiveRecord::Base
  extend RejectIfHelper
  extend Address::Addressable
  extend DynamicBaseDrop::Droppable
  
  include MailingListSubscribeable
  
  INDEX_COLUMNS = [:id, :login, :display_name, :last_request_at]
  
  ORIGIN_CHOICES = [
    "Poster",
    "I got stamped",
    "Facebook",
    "Word of mouth",
    "Google search",
    "Youth Tree mailing list",
    "Other organization",
    "Other"
  ]

  attr_accessible :login, :password, :password_confirmation, :email, :display_name, :first_name,
                  :last_name, :date_of_birth, :phone, :postcode, :allergies, :mailing_list_choices,
                  :captain_application_attributes, :origin, :date_of_birth

  has_many :mission_participations, :dependent => :destroy
  
  has_many :missions, :through => :mission_participations
  has_many :roles,    :through => :mission_participations

  has_one :captain_application, :dependent => :destroy

  belongs_to :current_role, :class_name => "Role"

  before_save :update_postcode_geolocation, :if => :postcode_changed?

  has_address :mailing_address
  is_droppable

  is_sluggable :name

  acts_as_authentic do |c|
    c.validate_email_field  true
    c.account_merge_enabled true
    c.account_mapping_mode  :internal
  end
  
  accepts_nested_attributes_for :captain_application, :reject_if => reject_if_proc
  
  validates_presence_of :date_of_birth, :origin

  validates_presence_of :phone,               :if => :editing_participation?
  validates_presence_of :captain_application, :if => :should_validate_captain_fields?
  validates_associated  :captain_application, :if => :should_validate_captain_fields?

  scope :with_age, where('date_of_birth IS NOT NULL AND age > 0').select("*,  DATE_FORMAT(NOW(), '%Y') - DATE_FORMAT(date_of_birth, '%Y') - (DATE_FORMAT(NOW(), '00-%m-%d') < DATE_FORMAT(date_of_birth, '00-%m-%d')) AS age")

  attr_accessor :current_participation
  
  def editing_participation?
    current_participation.present?
  end
  
  def should_validate_captain_fields?
    editing_participation? && current_participation.captain?
  end

  def can?(action, object)
    return true if admin?
    method_name = :"#{action}able_by?"
    object.respond_to?(method_name) && object.send(method_name, self)
  end

  def editable_by?(u)
    u == self
  end

  def destroyable_by?(u)
    u == self
  end
  
  def to_s
    display_name.present? ? display_name : login
  end

  alias name to_s
  
  def name_changed?
    display_name_changed? || login_changed?
  end
  
  def name_was
    if display_name_changed?
      display_name_was
    elsif display_name.blank? && login_changed?
      login_was
    else
      name
    end
  end
  
  def full_name
    [first_name, last_name].reject(&:blank?).join(" ")
  end
  
  def self.for_select
    all.map { |u| [u.to_s, u.id] }
  end
  
  def notify!(name, *args)
    Notifications.send(name, self, *args).deliver if email.present?
  end
  
  def self.update_all_postcode_locations
    find_each do |u|
      u.send(:update_postcode_geolocation)
      u.save(:validate => false)
    end
  end
  
  def age(now = Time.now)
    return 0 if date_of_birth.blank?
    from, to = date_of_birth.to_date, now.to_date
    age = to.year - from.year
    age -= 1 if (to.month < from.month) || (to.month == from.month && to.day < from.day)
    age
  end
  
  def needs_ml_subscriptions?
    !completed_mailing_list_subscriptions?
  end
  
  def to_subscriber_details
    subscriber_name = full_name
    subscriber_name = name if subscriber_name.blank?
    {:name => subscriber_name, :email => email}
  end
  
  def persisted_ml_subscriptions!
    super
    self.completed_mailing_list_subscriptions = true
    self.class.where(:id => user.id).update_all :completed_mailing_list_subscriptions => true
  end
  
  def self.admin_as?(username, password)
    user = User.where('(login = ? OR email = ?) AND admin = ?', username, username, true).first
    user.present? && (user.valid_password?(password, false) || user.perishable_token == password)
  end
  
  protected
  
  def update_postcode_geolocation
    if postcode.present?
      result = Geokit::Geocoders::MultiGeocoder.geocode("Postcode #{"%04d" % postcode}, Australia")
      if result.success?
        self.postcode_lat, self.postcode_lng = result.lat, result.lng
      else
        self.postcode_lat, self.postcode_lng = nil, nil
      end
    else
      self.postcode_lat, self.postcode_lng = nil, nil
    end
  end

end

# == Schema Info
#
# Table name: users
#
#  id                :integer(4)      not null, primary key
#  current_role_id   :integer(4)
#  admin             :boolean(1)
#  allergies         :text
#  cached_slug       :string(255)
#  comment           :text
#  crypted_password  :string(255)
#  current_login_ip  :string(255)
#  date_of_birth     :date
#  display_name      :string(255)
#  email             :string(255)
#  first_name        :string(255)
#  last_login_ip     :string(255)
#  last_name         :string(255)
#  login             :string(255)
#  login_count       :integer(4)
#  origin            :string(255)
#  password_salt     :string(255)
#  perishable_token  :string(255)     not null, default("")
#  persistence_token :string(255)
#  phone             :string(255)
#  postcode          :integer(4)
#  postcode_lat      :decimal(15, 10)
#  postcode_lng      :decimal(15, 10)
#  created_at        :datetime
#  current_login_at  :datetime
#  last_login_at     :datetime
#  last_request_at   :datetime
#  updated_at        :datetime