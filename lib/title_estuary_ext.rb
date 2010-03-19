module TitleEstuaryExt
  
  def self.included(p)
    p.helper_method(:page_title_is)
  end
  
  protected
  
  def page_title_is(title)
    self.page_title = title
  end
  
  def interpolation_options
    @__interpolation_options ||= {}
  end
  
  def add_title_variables!(mapping = {})
    interpolation_options.merge!(mapping)
  end
  
end
