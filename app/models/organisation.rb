class Organisation < ActiveRecord::Base
  
  has_one :address, :as => :addressable
  has_many :missions
  
end


# == Schema Info
#
# Table name: organisations
#
#  id          :integer(4)      not null, primary key
#  description :text
#  name        :string(255)
#  permalink   :string(255)
#  telephone   :string(255)
#  website     :string(255)
#  created_at  :datetime
#  updated_at  :datetime