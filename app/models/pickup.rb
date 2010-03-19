class Pickup < ActiveRecord::Base
  
  attr_accessible :name
  
  extend Address::Addressable
  has_address
  
  validates_presence_of :name, :address
  
  has_many :mission_pickups
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