class Admin::BaseController < AdminController
  inherit_resources
  
  protected
  
  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.paginate(:page => params[:page]))
  end
  
end