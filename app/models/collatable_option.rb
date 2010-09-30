class CollatableOption < ActiveRecord::Base
  
  validates_presence_of :name, :value, :scope_key
  
  def self.for_select
    ActiveSupport::OrderedHash.new.tap do |hash|
      select("name, id").all.each { |option| hash[option.name] = option.id }
    end    
  end
  
  def self.id_to_names
    select("id, name").all.inject({}) do |acc, current|
      acc[current.id] = current.name
      acc
    end
  end
  
  def self.id_to_values
    select("id, value").all.inject({}) do |acc, current|
      acc[current.id] = current.value
      acc
    end
  end
  
end
