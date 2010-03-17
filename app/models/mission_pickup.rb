class MissionPickup < ActiveRecord::Base
  belongs_to :mission
  belongs_to :pickup
  
  attr_accessible :pickup_id, :mission_id
  
end
