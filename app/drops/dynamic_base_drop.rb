class DynamicBaseDrop < Liquid::Drop
  
  def self.[](object)
    result = nil
    object.class.ancestors.each do |ancestor|
      break if ancestor >= ActiveRecord::Base
      klass = "#{ancestor.name}Drop".constantize rescue nil
      if klass
        result = klass.new(object)
        break
      end
    end
    result || object.attributes
  end
  
  module Droppable    
    def is_droppable
      define_method(:to_liquid) { DynamicBaseDrop[self] }
    end
  end
  
  def self.inherited(parent)
    method_name = parent.resource_class_name.underscore.to_sym
    alias_method method_name, :resource
  end
  
  def initialize(resource)
    resource_is resource
  end
  
  def self.accessible!(*args)
    args.each do |arg|
      define_method(arg.to_sym) { resource.try(arg.to_sym) }
    end
  end
  
  def self.resource_class_name
    self.name.gsub(/Drop$/, '')
  end
  
  def self.resource_class
    resource_class_name.constantize
  end
  
  protected
  
  def resource_class_name
    self.class.resource_class_name
  end
  
  def resource_class
    self.class.resource_class
  end
  
  def current_ivar_scope
    :"@#{resource_class_name.underscore}"
  end
  
  def resource
    @resource
  end
  
  def resource_is(resource)
    @resource = resource
    instance_variable_set(current_ivar_scope, resource)
  end
  
end