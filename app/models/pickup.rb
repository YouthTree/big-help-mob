class Pickup < ActiveRecord::Base
  extend Address::Addressable
  extend DynamicBaseDrop::Droppable
  
  attr_accessible :name
  
  has_address
  is_droppable
  
  validates_presence_of :name, :address
  
  has_many :mission_pickups, :dependent => :destroy
  has_many :missions, :through => :mission_pickups
  
end

# == Schema Info
#
# Table name: pickups
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime