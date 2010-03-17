class Pickup < ActiveRecord::Base
  
  attr_accessible :name
  
  extend Address::Addressable
  has_address
  
  validates_presence_of :name, :address
  
  has_many :mission_pickups
  has_many :missions, :through => :mission_pickups
  
end