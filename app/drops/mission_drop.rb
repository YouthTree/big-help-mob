class MissionDrop < DynamicBaseDrop
  
  accessible! :name, :description
              
  def address
    address.to_s
  end
  
  def pickups
    mission.mission_pickups
  end
  
  def pickup_locations
    mission.pickups
  end
  
end