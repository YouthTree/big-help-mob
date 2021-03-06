class Role < ActiveRecord::Base
  extend DynamicBaseDrop::Droppable
  
  PUBLIC_ROLES = %w(captain sidekick)
  
  validates_presence_of :name
  
  attr_accessible :name
  
  is_droppable
  
  def to_s
    name.humanize
  end
  
  def self.[](name)
    where(:name => name.to_s).first
  end
  
  def self.for_select
    all.map { |r| [r.to_s, r.id] }
  end
  
end

# == Schema Info
#
# Table name: roles
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime