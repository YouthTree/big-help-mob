module AssetsHelper
  
  # Equiv. to include_javascripts in the header
  def has_jammit_js(*args)
    content_for :extra_head, include_javascripts(*args)
  end
  
  # Equiv. to include_stylesheets in the header
  def has_jammit_css(*args)
    content_for :extra_head, include_stylesheets(*args)
  end
  
  # Equiv. to javascript_include_tag in the header
  def has_js(*args)
    content_for :extra_head, javascript_include_tag(*args)
  end
  
  # Equiv. to stylesheet_link_tag in the header
  def has_css(*args)
    content_for :extra_head, stylesheet_link_tag(*args)
  end
  
end