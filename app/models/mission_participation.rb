class MissionParticipation < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :mission
  belongs_to :role
  
  validates_presence_of :user, :mission
  
  attr_accessible :mission_id, :user_attributes
  
  accepts_nested_attributes_for :user
  
  scope :with_role, includes(:role).where('role_id IS NOT NULL')
  scope :for_user, lambda { |u| includes(:user).where(:user_id => u.id) }

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
  
  def role_name
    self.role.try(:name)
  end
  
  def role_name=(value)
    self.role = Role::PUBLIC_ROLES.include?(value) ? Role[value] : nil
  end
  
  def update_with_conditional_save(attributes, perform_save = true)
    self.attributes = attributes
    perform_save && save
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