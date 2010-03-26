module Admin::MissionsHelper
  
  def render_new_question_form(form)
    form.fields_for :questions, MissionQuestion.new, :child_index => 'QUESTION_IDX' do |qf|
      render :partial => 'question_form', :object => qf
    end
  end
  
end
