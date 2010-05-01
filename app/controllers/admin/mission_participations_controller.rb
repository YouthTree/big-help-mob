class Admin::MissionParticipationsController < Admin::BaseController
  
  belongs_to :user, :mission, :polymorphic => true, :finder => :find_using_slug!
  
  protected
  
  def create_resource(object)
    object.skip_extra_validation = true
    super
  end
  
  def update_resource(object, attributes)
    object.skip_extra_validation = true
    super
  end
  
  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.paginate(:page => params[:page], :include => [:role, :mission]))
  end
  
end
