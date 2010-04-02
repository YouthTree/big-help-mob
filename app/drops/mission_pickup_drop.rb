class MissionPickupDrop < DynamicBaseDrop
  
  accessible! :pickup
  
  def address
    pickup.address
  end
  
  def name
    pickup.name
  end
  
  def time
    mission_pickup.pickup_at && ::I18n.l(mission_pickup.pickup_at, :format => :pickup_time)
  end
  
end