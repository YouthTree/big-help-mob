module Admin::MissionsHelper
  
  def render_new_question_form(form)
    form.fields_for :questions, MissionQuestion.new, :child_index => 'QUESTION_IDX' do |qf|
      render :partial => 'question_form', :object => qf
    end
  end
  
  def participations_listing(collection, options = {})
    options.reverse_merge!({
      :participations => collection,
      :show_state     => true,
      :show_name      => true,
      :show_role      => true
    })
    options[:column_count] = [:show_role, :show_name, :show_state].select { |k| options[k] }.size
    render :partial => 'participation_listing', :locals => options
  end
  
end
