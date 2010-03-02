class User < ActiveRecord::Base

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

end
