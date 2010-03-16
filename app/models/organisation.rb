class Organisation < ActiveRecord::Base
  
  has_one :address, :as => :addressable
  has_many :missions
  
  def to_s
    name
  end
  
  validates_presence_of :description, :name, :on => :create, :message => "can't be blank"
  
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