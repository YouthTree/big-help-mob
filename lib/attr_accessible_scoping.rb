module AttrAccessibleScoping
  
  UnassignableAttribute = Class.new(StandardError)  
  
  class << self
    
    attr_accessor :verbose
    
    def disabled?
      !!Thread.current[:attr_accessible_disabled]
    end
    
    def disable!
      Thread.current[:attr_accessible_disabled] = true
    end
    
    def enable!
      Thread.current[:attr_accessible_disabled] = nil
    end
    
    def disable
      disabled = disabled?
      disable! if !disabled
      begin
        yield if block_given?
      ensure
        enable! if disabled
      end
    end
    
    def install!
      ActiveRecord::Base.send(:include, ARMixin)
    end
    
  end
  
  module ARMixin
    
    def self.included(parent)
      parent.alias_method_chain :remove_attributes_protected_from_mass_assignment, :global_disable
    end
    
    def remove_attributes_protected_from_mass_assignment_with_global_disable(attributes)
      unless AttrAccessibleScoping.disabled? || (self.class.accessible_attributes && self.class.accessible_attributes.include?("all"))
        trusted_attributes = Array(self.class.accessible_attributes)
        attributes.each_pair do |k, v|
          raise UnassignableAttribute, "The attribute #{k} can't be assigned on #{self.class.name}" unless trusted_attributes.include?(k.to_s.gsub(/\(\d+\w\)$/, ''))
        end
      end
      attributes
    end
    
  end
  
  install!
  
end