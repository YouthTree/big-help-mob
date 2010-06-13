class Admin::FlickrPhotosController < Admin::BaseController

  belongs_to :mission, :finder => :find_using_slug!

  protected

  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.paginate(:page => params[:page], :include => :mission))
  end

end
