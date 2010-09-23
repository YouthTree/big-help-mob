# Wrapper class for password resets. OF DOOM.
class PasswordReset
  extend  ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :email, :password, :password_confirmation
  attr_reader   :user

  validates_presence_of :password, :password_confirmation, :if => :persisted?
  validates_presence_of :email, :user,                     :if => :new_record?
  
  validates_confirmation_of :password,                     :if => :persisted?
  

  def self.find(token)
    return if token.blank?
    user = User.find_using_perishable_token(token.to_s.strip) 
    return if user.blank?
    self.new({}, user, true)
  end
  
  def initialize(params = {}, user = nil, persisted = false)
    @user            = user
    @persisted       = persisted
    self.attributes  = params
  end

  def create
    valid?.tap do |value|
      user.reset_perishable_token!
      user.notify! :password_reset
    end
  end

  def update(attributes = {})
    return false if new_record?
    self.attributes = attributes
    valid?.tap { |v| user.update_password!(password) if v }
  end
  
  def save
    new_record? && create
  end
  
  def attributes=(attributes)
    attributes = (attributes || {}).symbolize_keys
    (attributes.keys & [:password, :password_confirmation, :email]).each do |v|
      send(:"#{v}=", attributes[v].to_s)
    end
    load_from_email if attributes[:email].present? && new_record?
  end
  
  def new_record?
    !persisted?
  end
  
  def persisted?
    @persisted
  end
  
  def id
    @user.try(:perishable_token)
  end
  
  protected
  
  def load_from_email
    @user = email.blank? ? nil : find_user_by_email(email)
  end
  
  def find_user_by_email(email)
    users = User.where(:email => email).all
    users.detect { |u| u.using_password? } || users.first
  end
  
end
