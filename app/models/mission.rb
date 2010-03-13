class Mission < ActiveRecord::Base
  
  # Validations
  validates_presence_of :name, :on => :create, :message => "can't be blank"

  # Associations
  
  has_one    :address, :as => :addressable
  belongs_to :organisation

  # Model methods

end
