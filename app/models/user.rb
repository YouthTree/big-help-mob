class User < ActiveRecord::Base
  extend RejectIfHelper
  extend Address::Addressable
  extend DynamicBaseDrop::Droppable
  
  include MailingListSubscribeable
  
  INDEX_COLUMNS = [:id, :login, :display_name, :last_request_at]
  
  ORIGIN_CHOICES = [
    "I'd rather not say",
    "Poster",
    "I got stamped",
    "Facebook - My Friends",
    "Facebook - Advert",
    "Facebook - The Big Help Mob page",
    "Word of mouth",
    "Google search",
    "Youth Tree mailing list",
    "Other organization",
    "Other"
  ]
  
  VOLUNTEERING_CHOICES = [
    ["No, I haven't.", false],
    ["Yes, I have.",   true]
  ]

  attr_accessible :login, :password, :password_confirmation, :email, :display_name, :first_name,
                  :last_name, :date_of_birth, :phone, :postcode, :allergies, :mailing_list_choices,
                  :captain_application_attributes, :origin, :volunteered_in_last_year

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
    c.validate_login_field  false
    c.account_merge_enabled true
    c.account_mapping_mode  :internal
  end
  
  accepts_nested_attributes_for :captain_application, :reject_if => reject_if_proc
  
  validates_presence_of :date_of_birth, :origin

  validates_presence_of :phone,               :if => :editing_participation?
  validates_presence_of :captain_application, :if => :should_validate_captain_fields?
  validates_associated  :captain_application, :if => :should_validate_captain_fields?
  validate              :ensure_name_is_filled_in

  scope :with_age, where('date_of_birth IS NOT NULL AND EXTRACT(year from AGE(date_of_birth)) > 0').select("*,  EXTRACT(year from AGE(date_of_birth)) AS age")

  attr_accessor :current_participation
  
  def self.find_by_email_or_login(login)
    find_by_email(login) || find_by_login(login)
  end
  
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
  
  def name
    if display_name?
      display_name
    elsif full_name.present?
      full_name
    elsif login?
      login
    else
      "Unknown User"
    end
  end

  def name_changed?
    return display_name_changed? if display_name?
    return full_name_changed?    if full_name?
    return login_changed?        if login?
    return false
  end
  
  def full_name_changed?
    first_name_changed? || last_name_changed?
  end
  
  def name_was
    if display_name_changed?
      display_name_was
    elsif first_name_changed?
      [(first_name_was || first_name), (last_name_was || last_name)].join(" ")
    elsif display_name.blank? && login_changed?
      login_was
    else
      name
    end
  end
  
  def full_name
    return nil unless first_name? || last_name?
    [first_name, last_name].reject(&:blank?).join(" ")
  end
  
  def full_name?
    full_name.present?
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
    self.class.where(:id => id).update_all :completed_mailing_list_subscriptions => true
  end
  
  def date_of_birth
    value = read_attribute(:date_of_birth)
    value.present? ? value : default_date_of_birth
  end
  
  def default_date_of_birth
    new_record? ? Date.new(1990, 1, 1) : nil
  end
  
  def self.admin_as?(username, password)
    user = User.where('(login = ? OR email = ?) AND admin = ?', username, username, true).first
    user.present? && (user.valid_password?(password, false) || user.perishable_token == password)
  end
  
  def ensure_name_is_filled_in
    if first_name.blank?
      errors.add :full_name, "first name must be filled in"
      errors.add :first_name, :blank
    end
    if last_name.blank?
      errors.add :full_name, "last name must be filled in"
      errors.add :last_name, :blank
    end
  end
  
  def update_password!(password)
    self.password              = password
    self.password_confirmation = password
    save :validate => false
    reset_perishable_token!
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