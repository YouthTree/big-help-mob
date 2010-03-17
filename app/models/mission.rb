class Mission < ActiveRecord::Base
  extend Address::Addressable
  
  # Validations
  validates_presence_of :name, :occurs_at, :organisation

  # Associations
  
  has_address
  
  has_many :mission_pickups
  has_many :pickups, :through => :mission_pickups
  
  belongs_to :organisation
  belongs_to :user

  attr_accessible :organisation_id, :user_id, :description, :name

  # Model methods

end

# == Schema Info
#
# Table name: missions
#
#  id              :integer(4)      not null, primary key
#  organisation_id :integer(4)
#  user_id         :integer(4)
#  description     :text            not null, default("")
#  name            :string(255)     not null
#  created_at      :datetime
#  occurs_at       :datetime        not null
#  updated_at      :datetime