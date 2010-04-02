class DynamicTemplate < ActiveRecord::Base
  
  module Templateable
    
    def has_dynamic_templates(name = :dynamic_templates)
      has_many name, :as => :parent, :class_name => "DynamicTemplate"
      class_eval do
        def render_dynamic_template(content_type, key, scope = {})
          DynamicTemplate.get(self, content_type, key, scope)
        end
      end
    end
    
  end
  
  VALID_CONTENT_TYPES  = %w(text html)
  CONTENT_TYPE_MAPPING = {
    'text' => "Plain Text",
    'html' => "HTML / Rich Text"
  }  
  
  def self.content_types_for_select
    VALID_CONTENT_TYPES.map { |ct| [CONTENT_TYPE_MAPPING[ct], ct] }
  end
  
  def self.has_parts(*args)
    args.each do |part|
      part = part.to_sym
      define_method(part) { read_part(part) }
      define_method(:"#{part}=") { |v| write_part(part, v) }
      class_eval(<<-END, __FILE__, __LINE__)
        def #{part}                                #  def awesome
          read_part #{part.to_s.inspect}           #    read_part "awesome"
        end                                        #  end
        
        def #{part}=(value)                        #  def awesome=(value)
          write_part #{part.to_s.inspect}, value   #    write_part "awesome", value
        end                                        #  end
        
        def render_#{part}(scope = {})             #  def render_awesome(scope = {})
          render_part #{part.to_s.inspect}, scope  #    render_part "awesome", scope
        end                                        #  end
      END
    end
  end
  
  has_parts :content
  
  belongs_to :parent, :polymorphic => true
  
  validates_presence_of :key, :content
  validates_format_of   :key, :with => /^[\w\-\.]+$/
  validates_inclusion_of :content_type, :in => VALID_CONTENT_TYPES
  
  serialize :parts
  
  def parts
    current = read_attribute(:parts)
    current.is_a?(Hash) ? current : write_attribute(:parts, {})
  end
  
  def parts=(value)
    if value.blank?
      write_attribute(:parts, {})
    elsif !value.is_a?(Hash)
      return false
    else
      parts.merge!(value.stringify_keys)
    end
  end
  
  def read_part(key)
    parts[key.to_s]
  end
  
  alias part read_part
  
  def write_part(key, value)
    key = key.to_s
    if value.blank?
      parts.delete(key)
    else
      parts[key] = value
    end
  end
  
  def render_part(key, scope = {})
    template = read_part(key)
    if template.blank?
      return ""
    else
      Liquid::Template.parse(template).render(scope.stringify_keys)
    end
  end
  
  def self.render(key, scope = {})
    template = find_by_key(key.to_s)
    template.present? ? template.render_content(scope) : ""
  end
  
  def self.for(parent)
    where(:parent_type => parent.class.name, :parent_id => parent.id)
  end
  
  def self.all_with_default(key, parent)
    where '(key = ? parent_type = ? AND parent_id = ?) OR key = ?',
          key, parent.class.name, parent.id, "#{key}.default"
  end
  
  def self.for_content_type(type)
    where(:content_type => type.to_s)
  end
  
  def self.get(parent, content_type, key, scope = {})
    default = for_content_type(content_type).for(parent).render(key, scope)
    default.blank? ? default_for(content_type, key, scope) : default
  end
  
  def self.default_for(content_type, key, scope = {})
    item = for_content_type(content_type).where(:key => "#{key}.default").first
    item.present? ? item.render_content(scope) : ""
  end
  
end


# == Schema Info
#
# Table name: dynamic_templates
#
#  id            :integer(4)      not null, primary key
#  parent_id     :integer(4)
#  content_type  :string(255)
#  key           :string(255)
#  parent_type   :string(255)
#  raw_parts     :text
#  template_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime