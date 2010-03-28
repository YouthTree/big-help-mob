module TitleEstuaryExt
  
  def self.included(p)
    p.helper_method(:page_title_is, :hide_title?)
  end
  
  protected
  
  def hide_title?
    instance_variable_defined?(:@hide_title) && @hide_title
  end
  
  def hide_title!
    @hide_title = true
  end
  
  def show_title!
    @hide_title = false
  end
  
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
