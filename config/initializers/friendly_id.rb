Slug.attr_accessible :all

ActiveRecord::Base.class_eval do
  
  def self.include_slugs
    joins("INNER JOIN slugs ON slugs.sluggable_id = missions.id AND slugs.sluggable_type = '#{name}'")
  end
  
  def self.from_raw_slug(slug, sequence = 1)
    include_slugs.where(:slugs => {:scope => nil, :sequence => sequence, :name => slug}).first
  end
  
  def self.from_slug(slug)
    record = nil
    record ||= where('cached_slug = ?', slug).first if column_names.include?(:cached_slug)
    record ||= find_by_id(slug)
    record ||= include_slugs.from_raw_slug(slug)
    record || raise(ActiveRecord::RecordNotFound)
  end
  
end