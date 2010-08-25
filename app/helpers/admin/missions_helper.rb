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
  
  def report_field_checkbox(name, text)
    field_id = "report_#{name}"
    content = check_box_tag("report[#{name}]", '1', ParticipationReporter.default_for(name), :id => field_id)
    content << content_tag(:span, text, :class => 'report-field-label')
    content_tag(:label, content, :for => field_id)
  end
  
  def report_field_select(name, text, choices, options = {})
    field_id = "report_#{name}"
    field_name = "report[#{name}]"
    field_name << "[]" if options[:multiple]
    content  = content_tag(:label, text, :for => field_id, :class => 'left-label')
    content << " "
    default  = Array(ParticipationReporter.default_for(name))
    content << select_tag(field_name, options_for_select(choices, default), options.merge(:id => field_id))
    content
  end
  
  def pretty_age_range(object, type)
    max, min = object.send(:"maximum_#{type}_age"), object.send(:"minimum_#{type}_age")
    if min.blank? && max.blank?
      "May be any age."
    elsif min.blank?
      "Must be younger than #{max} years old."
    elsif max.blank?
      "Must be older than #{min} years old."
    else
      "Must be #{min} to #{max} years old."
    end
  end

end
