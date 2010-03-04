class Organisation < ActiveRecord::Base
  
  has_one :address, :as => :addressable
  has_many :missions
  
end
