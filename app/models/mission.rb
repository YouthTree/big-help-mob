class Mission < ActiveRecord::Base
  
  # Validations
  validates_presence_of :name, :occurs_at, :organisation,
                        :on => :create, :message => "can't be blank"

  # Associations
  
  has_one    :address, :as => :addressable
  belongs_to :organisation
  belongs_to :user

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