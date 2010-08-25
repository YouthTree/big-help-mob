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
      ActiveRecord::Base.extend(ARMixin)
    end
    
  end
  
  class Sanitizer < ActiveModel::MassAssignmentSecurity::WhiteList

    def deny?(attribute)
      return false if AttrAccessibleScoping.disabled? || self.include?("all")
      super
    end

    protected

    def warn!(attrs)
      super
      raise UnassignableAttribute.new("Unable to assign attributes: #{attrs.join(", ")}")
    end

  end

  module ARMixin

    def accessible_attributes
      if _accessible_attributes.blank? || !_accessible_attributes.is_a?(AttrAccessibleScoping::Sanitizer)
        existing = _accessible_attributes
        self._accessible_attributes = AttrAccessibleScoping::Sanitizer.new.tap do |w|
          w.logger = self.logger if self.respond_to?(:logger)
        end
        self._accessible_attributes += existing if existing.present?
      end
      _accessible_attributes
    end

  end
  
  install!
  
end