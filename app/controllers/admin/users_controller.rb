class Admin::UsersController < Admin::BaseController
  use_controller_exts :slugged_resource
  
  protected
  
  def collection
    @search ||= end_of_association_chain.search(params[:search])
    @users  ||= @search.paginate(:page => params[:page])
  end
  
end
