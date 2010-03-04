class Mission < ActiveRecord::Base
  
  # Validations
  validates_presence_of :name, :on => :create, :message => "can't be blank"

  # Associations
  
  has_one :address, :as => :addressable

  # Model methods

end
