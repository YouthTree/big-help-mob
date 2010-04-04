class User < ActiveRecord::Base
  extend Address::Addressable
  extend DynamicBaseDrop::Droppable
  
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
                  :last_name, :date_of_birth, :phone, :postcode, :allergies, :mailing_list_ids,
                  :captain_application_attributes, :origin, :date_of_birth

  has_many :mission_participations, :dependent => :destroy
  
  has_many :missions, :through => :mission_participations
  has_many :roles,    :through => :mission_participations

  has_one :captain_application, :dependent => :destroy

  belongs_to :current_role, :class_name => "Role"

  before_save :update_postcode_geolocation, :if => :postcode_changed?

  has_address :mailing_address
  is_droppable

  has_friendly_id :name, :use_slug => true, :reserved_words => ["add_rxp_auth", "current"]

  acts_as_authentic do |c|
    c.validate_email_field  true
    c.account_merge_enabled true
    c.account_mapping_mode  :internal
  end
  
  accepts_nested_attributes_for :captain_application, :reject_if => proc { |a| a.values.all? { |v| v.blank? || v.to_s == "0" } }
  
  validates_presence_of :date_of_birth, :origin
  
  validates_inclusion_of :origin, :in => ORIGIN_CHOICES,
    :message => :unknown_origin_choice, :allow_blank => true

  validates_presence_of :phone, :captain_application, :if => :should_validate_captain_fields?
  validates_associated  :captain_application,         :if => :should_validate_captain_fields?

  scope :with_age, where('date_of_birth IS NOT NULL AN age > 3').select("*,  AS age")

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
  
  def mailing_lists
    @mailing_lists ||= MailingLists.new(self)
  end
  
  def mailing_list_ids
    mailing_lists.ids
  end
  
  def mailing_list_ids=(value)
    mailing_lists.ids = value
  end
  
  protected
  
  def normalize_friendly_id(text)
    text.to_url
  end
  
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