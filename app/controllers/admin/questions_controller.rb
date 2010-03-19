class Admin::QuestionsController < Admin::BaseController
  
  def reorder
    Question.update_order(params[:question_ids]) if params[:question_ids]
    redirect_to :admin_questions
  end
  
  protected
  
  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.ordered.all)
  end
  
end
