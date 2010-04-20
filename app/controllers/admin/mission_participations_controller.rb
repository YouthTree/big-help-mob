class Admin::MissionParticipationsController < Admin::BaseController
  
  belongs_to :user, :mission, :polymorphic => true, :finder => :find_sluggy
  
  protected
  
  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.paginate(:page => params[:page], :include => [:role, :mission]))
  end
  
end
