class User < ActiveRecord::Base

  INDEX_COLUMNS = [:id, :login, :display_name, :last_request_at]

  attr_accessible :login, :password, :password_confirmation, :email, :display_name, :first_name,
                  :last_name, :date_of_birth, :phone, :postcode, :allergies, :mailing_list_ids

  has_many :mission_participations
  has_many :missions, :through => :mission_participations
  has_many :roles,    :through => :mission_participations

  belongs_to :current_role, :class_name => "Role"

  after_save   :update_mailchimp_subscription
  after_create :save_initial_mailing_list_subscripts

  acts_as_authentic do |c|
    c.account_merge_enabled true
    c.account_mapping_mode  :internal
    c.validate_email_field  false
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
  
  def mailing_list_names
    HominidWrapper.local_id_to_name_mapping(mailing_list_ids)
  end
  
  def mailing_list_ids
    if new_record?
      @mailing_list_ids ||= []
    elsif email.present?
      @mailing_list_ids ||= HominidWrapper.subscriptions_for_user(self)
    else
      []
    end
  end
  
  def mailing_list_ids=(ids)
    if new_record?
      @mailing_list_ids = ids
    else
      return false unless email.present?
      HominidWrapper.update_user_subscriptions(self, ids) if ids != mailing_list_ids
      # Force a refresh
      @mailing_list_ids = nil
    end  
    true
  end
  
  def self.for_select
    all.map { |u| [u.to_s, u.id] }
  end
  
  def self.created_stats_by_day(from = Date.today - 14, to = Date.today)
    from, to = from.to_date, to.to_date
    users = select("DATE(users.created_at) AS users_date, count(*) AS count_all").group("users_date")
    users = users.having("users_date > ? AND users_date < ?", from - 1, to + 1).all
    users = users.inject({}) { |a, c| a[Date.parse(c.users_date)] = c.count_all.to_i; a }
    results = ActiveSupport::OrderedHash.new
    while from <= to
      results[from] = users[from].to_i
      from += 1
    end
    results
  end
  
  protected
  
  def update_mailchimp_subscription
    HominidWrapper.update_user_email(self) if email_changed? && !email.blank? && mailing_list_ids.present?
  end
  
  def save_initial_mailing_list_subscripts
    HominidWrapper.update_user_subscriptions(self, @mailing_list_ids) if @mailing_list_ids.present?
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
#  password_salt     :string(255)
#  persistence_token :string(255)
#  phone             :string(255)
#  postcode          :integer(4)
#  created_at        :datetime
#  current_login_at  :datetime
#  last_login_at     :datetime
#  last_request_at   :datetime
#  updated_at        :datetime