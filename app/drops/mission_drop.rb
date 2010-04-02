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
  
  def occurs_at
    I18n.l(mission.occurs_at, :format => :simple).gsub(/^0/, '').gsub(/0(\d:\d{2})/, '\1')
  end
  
end