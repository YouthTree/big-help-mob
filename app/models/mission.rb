class Mission < ActiveRecord::Base
  extend Address::Addressable
  
  scope :next, where(:state => 'published')
  
  # Validations
  validates_presence_of :name, :occurs_at, :organisation

  # Associations
  
  has_address
  
  has_many :mission_pickups
  has_many :pickups, :through => :mission_pickups
  
  belongs_to :organisation
  belongs_to :user

  attr_accessible :organisation_id, :user_id, :description, :name

  state_machine :initial => :created do
    state :created
    state :preparing
    state :approved
    state :completed
    state :cancelled
    
    event :prepare do
      transition :created => :prepared
    end
    
    event :approve do
      transition :prepared => :approved
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
      [name, se.to_s]
    end
  end

  def to_param
    "#{self.id}-#{self.to_slug}"
  end

  def to_slug
    name.parameterize
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