# Wrapper class for password resets. OF DOOM.
class PasswordReset
  extend  ActiveModel::Naming
  include ActiveModel::Conversion
  
  attr_accessor :email, :password, :password_confirmation
  
  def self.human_name
    model_name.human
  end

  def self.find(token)
    return if token.blank?
    user = User.find_using_perishable_token(token) 
    return if user.blank?
    self.new({}, user, false)
  end
  
  def initialize(params = {}, user = nil, new_record = true)
    @user            = user
    @new_record      = !!new_record
    @errors          = ActiveModel::Errors.new(self)
    @real_validation = false
    self.attributes  = params
  end
  
  def create
    @real_validation = true
    return false if !valid?
    @user.reset_perishable_token!
    @user.notify! :password_reset
    true
  end
  
  def update(attributes = {})
    @real_validation = true
    return false if new_record?
    self.attributes = attributes if attributes.present?
    if password.present? && @user.update_attributes(:password => password, :password_confirmation => password_confirmation)
      @user.reset_perishable_token!
      true
    else
      false
    end
  end
  
  def save
    create if new_record?
  end
  
  def valid?
    @user.present? && errors.empty?
  end
  
  def errors
    return ActiveModel::Errors.new(self) unless @real_validation
    new_record? ? create_errors_for_email : create_errors_for_update
  end
  
  def attributes=(attributes)
    real_attributes = (attributes || {}).symbolize_keys
    [:password, :password_confirmation, :email].each do |v|
      next if !real_attributes.has_key?(v)
      send(:"#{v}=", attributes[v].to_s)
    end
    load_from_email if real_attributes.has_key?(:email)
  end
  
  def new_record?
    @new_record
  end
  
  def persisted?
    !new_record?
  end
  
  def id
    @user.try(:perishable_token)
  end
  
  protected
  
  def load_from_email
    @user = (email.blank? ? nil : User.find_by_email(email))
  end
  
  def create_errors_for_email
    @errors.clear
    @errors
  end
  
  def create_errors_for_update
    errors = @user.errors.dup
    errors.add :password, :blank if password.blank?
    errors
  end
  
end
