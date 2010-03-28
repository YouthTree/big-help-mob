require 'yaml'

class Settings
  
  cattr_accessor :settings_path
  self.settings_path ||= Rails.root.join("config", "settings.yml")
  
  def initialize(hash = {})
    @hash = Hash.new { |h,k| h[k] = self.class.new }
    hash.each_pair { |k, v| self[k] = v }
  end
  
  def to_hash
    unpack_attr @hash
  end
  
  def []=(k, v)
    @hash[k.to_sym] = normalize_attr(v)
  end
  
  def [](k)
    @hash[k.to_sym]
  end
  
  def has?(key)
    key = key.to_sym
    @hash.has_key?(key) && @hash[key].present?
  end
  
  def blank?
    @hash.blank?
  end
  
  def present?
    !blank?
  end
  
  def method_missing(name, *args, &blk)
    name = name.to_s
    key, modifier = name[0..-2], name[-1, 1]
    case modifier
    when '?'
      has?(key)
    when '='
      send(:[]=, key, *args)
    else
      self[name]
    end
  end
  
  def respond_to?(name, key = false)
    true
  end
  
  class << self
    
    def load_from_file
      contents = YAML.load(File.read(self.settings_path))
      (contents["default"] || {}).deep_merge(contents[Rails.env] || {})
    end
    
    def default
      @@__default ||= begin
        groups = [load_from_file]
        self.new(groups.inject({}) { |a,v| a.deep_merge(v) })
      end
    end
    
    def method_missing(name, *args, &blk)
      default.send(name, *args, &blk)
    end

    def respond_to?(name, key = false)
      true
    end
    
  end
  
  protected
  
  def normalize_attr(value)
    case value
    when Hash
      self.class.new(value)
    when Array
      value.map { |v| normalize_attr(v) }
    else
      value
    end
  end
  
  def unpack_attr(value)
    case value
    when self.class
      value.to_hash
    when Hash
      returning({}) do |h|
        value.each_pair { |k,v| h[k] = unpack_attr(v) }
      end
    when Array
      value.map { |v| unpack_attr(v) }
    else
      value
    end
  end
  
end