module Admin::PickupsHelper
  
  def link_to_pickup(pickup, selected = false)
    link_to pickup.name, [:admin, pickup], pickup_data_options(pickup, selected)
  end
  
end
