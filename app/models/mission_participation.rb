class MissionParticipation < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :mission
  belongs_to :role
  
  validates_presence_of :user, :mission
  
  attr_accessible :mission_id
  
  scope :with_role, includes(:role).where('role_id IS NOT NULL')
  
  state_machine :initial => :created do
    state :created
    state :approved
    state :completed
    state :cancelled
    event :approve do
      transition :created => :approved
    end
    event :cancel do
      transition any => :cancelled
    end
    event :complete do
      transition :approved => :completed
    end
  end
  
end

# == Schema Info
#
# Table name: mission_participations
#
#  id         :integer(4)      not null, primary key
#  mission_id :integer(4)
#  role_id    :integer(4)
#  user_id    :integer(4)
#  state      :string(255)
#  created_at :datetime
#  updated_at :datetime