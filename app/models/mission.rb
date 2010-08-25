class Mission < ActiveRecord::Base
  extend RejectIfHelper
  extend Address::Addressable
  extend DynamicTemplate::Templateable
  extend DynamicBaseDrop::Droppable
  
  Error        = Class.new(StandardError)
  SignupClosed = Class.new(Error)
  
  attr_accessible :organisation_id, :user_id, :description, :name
  
  scope :next,      where(:state => ['preparing', 'approved']).order('occurs_at ASC')
  scope :viewable,  where(:state => ['preparing', 'approved', 'completed'])
  scope :completed, where(:state => 'completed').order('occurs_at DESC')
  
  # Validations
  validates_presence_of :name, :occurs_at, :organisation, :address_title

  validates_numericality_of :maximum_captain_age, :minimum_captain_age, :maximum_sidekick_age, :minimum_sidekick_age,
                            :allow_nil => true, :greater_than => 0, :less_than_or_equal_to => 100

  # Associations
  
  has_address
  has_dynamic_templates
  is_droppable
  
  is_sluggable :name
  
  has_many :mission_pickups, :dependent => :destroy
  has_many :pickups, :through => :mission_pickups
  
  has_many :mission_participations, :dependent => :destroy
  has_many :users, :through => :mission_participations
  has_many :questions, :class_name => "MissionQuestion"
  has_many :flickr_photos
  
  belongs_to :organisation
  
  accepts_nested_attributes_for :questions,       :reject_if => reject_if_proc(%w(all 0)), :allow_destroy => true
  accepts_nested_attributes_for :mission_pickups, :reject_if => reject_if_proc, :allow_destroy => true

  scope :optimize_viewable, includes(:address => nil, :mission_pickups => {:pickup => :address}, :questions => nil)
  
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
 
  def self.has_next?
    self.next.exists?
  end

  def state_events_for_select
    state_events.map do |se|
      name = ::I18n.t(:"#{self.class.model_name.underscore}.#{se}", :default => se.to_s.humanize, :scope => :"ui.state_events")
      [name, se]
    end
  end
  
  def participating?(user)
    mission_participations.exists?(:user_id => user.id)
  end
  
  def participation_for(user, role_name = nil)
    participation = mission_participations.optimize_editable.for_user(user).first
    if participation
      participation.mission = self
      if role_name.present? && participation.role_name != role_name
        raise SignupClosed unless signup_open?(role_name)
        participation.role_name = role_name
        participation.save(false)
      end
      participation
    else
      raise SignupClosed unless signup_open?(role_name)
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
  
  def normalize_friendly_id(text)
    text.to_url
  end
  
  def unstarted?
    %w(preparing approved).include?(self.state)
  end
  
  def signup_open?(role)
    role = role.to_s.underscore
    method_key = "#{role}_signup_open"
    respond_to?(method_key) && !!send(method_key)
  end
  
  def import_photoset!(photoset_id)
    flickr_photos.from_photoset!(photoset_id)
  end

  def self.for_select
    select('name, id').all.map { |m| [m.name, m.id] }
  end

end

# == Schema Info
#
# Table name: missions
#
#  id                   :integer(4)      not null, primary key
#  organisation_id      :integer(4)
#  user_id              :integer(4)
#  address_title        :string(255)
#  cached_slug          :string(255)
#  captain_signup_open  :boolean(1)      default(TRUE)
#  description          :text            not null, default("")
#  maximum_captain_age  :integer(4)
#  maximum_sidekick_age :integer(4)
#  minimum_captain_age  :integer(4)
#  minimum_sidekick_age :integer(4)
#  name                 :string(255)     not null
#  sidekick_signup_open :boolean(1)      default(TRUE)
#  state                :string(255)
#  created_at           :datetime
#  occurs_at            :datetime        not null
#  updated_at           :datetime
