class RPXIdentifier < ActiveRecord::Base
  
  attr_accessible :identifier, :provider_name
  
	validates_presence_of :identifier
	validates_uniqueness_of :identifier
	validates_presence_of :user_id
end
