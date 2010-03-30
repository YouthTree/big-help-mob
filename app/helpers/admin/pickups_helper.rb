module Admin::PickupsHelper
  
  def link_to_pickup(pickup, selected = false)
    link_to pickup.name, [:admin, pickup], pickup_data_options(pickup, selected)
  end
  
  def render_new_pickup_form(form)
    form.fields_for :mission_pickups, MissionPickup.new, :child_index => 'QUESTION_IDX' do |mpf|
      render :partial => 'pickup_form', :object => mpf
    end
  end
  
end
