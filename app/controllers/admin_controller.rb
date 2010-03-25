class AdminController < ApplicationController
  
  before_filter :require_user
  before_filter :require_admin
  around_filter :disable_attr_accessible
  
  protected
  
  def disable_attr_accessible
    AttrAccessibleScoping.disable { yield }
  end
  
  def require_admin
    redirect_to :root, :alert => tf('permissions.admin_denied') unless current_user.admin?
  end
  
end
