class Mission < ActiveRecord::Base
  extend Address::Addressable
  
  scope :next,     where(:state => 'preparing').order('occurs_at ASC')
  scope :viewable, where(:state => ['preparing', 'approved', 'completed'])
  
  # Validations
  validates_presence_of :name, :occurs_at, :organisation

  # Associations
  
  has_address
  
  has_many :mission_pickups
  has_many :pickups, :through => :mission_pickups
  
  has_many :mission_participations
  has_many :users, :through => :mission_participations
  has_many :questions, :class_name => "MissionQuestion"
  
  belongs_to :organisation
  belongs_to :user

  attr_accessible :organisation_id, :user_id, :description, :name
  
  accepts_nested_attributes_for :questions,       :reject_if => proc { |a| a.values.all? { |v| v.blank? || v.to_s == "0" } }, :allow_destroy => true
  accepts_nested_attributes_for :mission_pickups, :reject_if => proc { |a| a.values.all? { |v| v.blank? || v.to_s == "0" } }, :allow_destroy => true

  scope :optimize_viewable, includes(:address => nil, :pickups => :address, :questions => nil)

  state_machine :initial => :created do
    state :created
    state :preparing
    state :approved
    state :completed
    state :cancelled
    
    event :prepare do
      transition :created => :preparing
    end
    
    event :approve do
      transition :preparing => :approved
    end
    
    event :cancel do
      transition any => :cancelled
    end
    
    event :complete do
      transition :approved => :completed
    end
  end
  
  def state_events_for_select
    state_events.map do |se|
      name = ::I18n.t(:"#{self.class.model_name.underscore}.#{se}", :default => se.to_s.humanize, :scope => :"ui.state_events")
      [name, se]
    end
  end

  def to_param
    "#{self.id}-#{self.to_slug}"
  end

  def to_slug
    name.parameterize
  end
  
  def participating?(user)
    mission_participations.exists?(:user_id => user.id)
  end
  
  def participation_for(user, role_name = nil)
    participation = mission_participations.optimize_editable.for_user(user).first
    if participation
      participation.mission = self
      if role_name.present? && participation.role_name != role_name
        participation.role_name = role_name
        participation.save(false)
      end
      participation
    else
      mission_participations.build.tap do |p|
        p.role_name = role_name
        p.user      = user
        p.save :validate => false
      end
    end
  end
  
  def description_as_html
    description.to_s.html_safe
  end

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
#  state           :string(255)
#  created_at      :datetime
#  occurs_at       :datetime        not null
#  updated_at      :datetime