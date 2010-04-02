class PickupDrop < DynamicBaseDrop
  
  accessible! :name
  
  def address
    address.to_s
  end
  
end