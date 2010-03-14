class AdminController < ApplicationController
  
  before_filter :require_user
  before_filter :require_admin
  before_filter :trust_attributes_by_default
  
  protected
  
  def trust_attributes_by_default
    params.trust
  end
  
  def require_admin
    redirect_to :root, :alert => t('flash.permissions.admin_denied') unless current_user.admin?
  end
  
end
