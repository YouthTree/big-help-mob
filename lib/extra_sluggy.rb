module ExtraSluggy
  
  def self.for_counter(slug, counter = 0)
    counter.to_i < 1 ? slug : "#{slug}-#{counter}"
  end
  
  def is_sluggy(attribute)
    extend  FinderMethods
    include InstanceMethods
    class_attribute :sluggy_source
    self.sluggy_source = attribute.to_sym
    before_save :generate_slug
  end
  
  module ControllerExt
    
    protected
    
    def resource
      get_resource_ivar || set_resource_ivar(end_of_association_chain.find_sluggy(params[:id]))
    end
    
  end
  
  module FinderMethods
    
    def with_cached_slug(slug)
      where('cached_slug = ?', slug)
    end
    
    def from_param(param)
      where('cached_slug = ? OR id = ?', param, param.to_i)
    end
    
    def find_sluggy(id = nil)
      raise ActiveRecord::RecordNotFound if id.blank?
      from_param(id).first or raise ActiveRecord::RecordNotFound
    end
    
    def update_all_slugs!
      transaction do
        update_all 'cached_slug = NULL'
        find_each { |r| r.generate_slug!(true) }
      end
    end
    
  end
  
  module InstanceMethods
    
    def generate_slug(force = false)
      if cached_slug.blank? || force
        raw = send(self.sluggy_source).to_s
        return if raw.blank?
        raw_url = raw.to_url
        counter = 0
        slug    = ExtraSluggy.for_counter(raw_url, counter)
        scope = self.class
        scope = scope.where('id != ?', self.id) unless new_record?
        while scope.with_cached_slug(slug).exists?
          counter += 1
          slug = ExtraSluggy.for_counter(raw_url, counter)
        end
        self.cached_slug = slug
      end
    end
    
    def generate_slug!(force = false)
      generate_slug force
      save :validate => false
    end
    
    def to_param
      cached_slug.present? ? cached_slug : id.to_s
    end
    
  end
  
end