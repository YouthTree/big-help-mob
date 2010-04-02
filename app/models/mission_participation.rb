class MissionParticipation < ActiveRecord::Base
  extend DynamicBaseDrop::Droppable
  
  belongs_to :user
  belongs_to :mission
  belongs_to :role
  belongs_to :pickup, :class_name => "MissionPickup"
  
  validates_presence_of :user, :mission, :pickup
  validates_associated  :answers
  
  attr_accessible :mission_id, :user_attributes, :pickup_id, :answers
  
  after_validation :auto_approve, :on => :update
  
  accepts_nested_attributes_for :user
  
  serialize :raw_answers
  
  scope :with_role, where('role_id IS NOT NULL')
  scope :for_user,  lambda { |u| where(:user_id => u.id) }
  
  scope :optimize_editable, includes(:user => [:mailing_address, :captain_application], :pickup => {:pickup => :address}, :role => nil)

  is_droppable

  state_machine :initial => :created do
    state :created
    state :awaiting_approval
    state :approved
    state :completed
    state :cancelled
    
    event :await_approval do
      transition :created => :awaiting_approval
    end
    
    event :approve do
      transition [:created, :awaiting_approval] => :approved
    end
    
    event :cancel do
      transition any => :cancelled
    end
    
    event :complete do
      transition :approved => :completed
    end
    
    after_transition :created => :awaiting_approval do |mp, transition|
      mp.user.notify! :joined_mission, mp
    end
    
    after_transition [:created, :awaiting_approval] => :approved do |mp, transition|
      mp.user.notify! :mission_role_approved, mp
    end
    
  end
  
  def role_name
    ActiveSupport::StringInquirer.new(self.role.try(:name).to_s)
  end
  
  def role_name=(value)
    self.role = Role::PUBLIC_ROLES.include?(value) ? Role[value] : nil
  end
  
  def update_with_conditional_save(attributes, perform_save = true)
    self.attributes = attributes
    perform_save && save
  end
  
  def alternate_role
    Role::PUBLIC_ROLES[((Role::PUBLIC_ROLES.index(role_name) || 0) + 1) % Role::PUBLIC_ROLES.length]
  end
  
  def answers
    @answers ||= AnswerProxy.new(self)
  end
  
  def answers=(value)
    answers.attributes = value
  end
  
  def auto_approve
    approve(false) if created? || awaiting_approval?
  end
  
  def state_events_for_select
    state_events.map do |se|
      name = ::I18n.t(:"#{self.class.model_name.underscore}.#{se}", :default => se.to_s.humanize, :scope => :"ui.state_events")
      [name, se]
    end
  end
  
  def self.viewable_by(user)
    scope = self.includes(:mission => :address, :role => nil, :pickup => {:pickup => :address})
    public_states = %w(approved completed)
    if user.blank?
      scope = scope.where('mission_participations.state' => public_states)
    elsif !user.admin?
      scope = scope.where("mission_participations.user_id = ? OR mission_participations.state IN (?)", user.id, public_states)
    end
    scope
  end
  
end

# == Schema Info
#
# Table name: mission_participations
#
#  id          :integer(4)      not null, primary key
#  mission_id  :integer(4)
#  pickup_id   :integer(4)
#  role_id     :integer(4)
#  user_id     :integer(4)
#  raw_answers :text
#  state       :string(255)
#  created_at  :datetime
#  updated_at  :datetime