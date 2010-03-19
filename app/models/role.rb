class Role < ActiveRecord::Base
  
  validates_presence_of :name
  
  attr_accessible :name
  
  def to_s
    name.humanize
  end
  
  def self.[](name)
    where(:name => name).first
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