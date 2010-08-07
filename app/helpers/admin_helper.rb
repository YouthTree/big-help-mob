module AdminHelper
  
  def value_with_default(v, default = "Currently blank", &blk)
    inner = ""
    if v.present?
      inner = blk.present? ? capture(&blk) : v
    else
      inner = content_tag(:span, default, :class => 'default-value')
    end
    inner
  end
  
  alias vwd value_with_default
  
  def collection_sidebar
    sidebar_menu(parent_sidebar_content + resources_sidebar_content)
  end
  
  def object_sidebar
    name = current_resource_name
    inner_menu = parent_sidebar_content + resources_sidebar_content(name) + resource_sidebar_content(name)
    sidebar_menu(inner_menu)
  end
  
  def menu_link(*args, &blk)
    content_tag(:li, link_to(*args, &blk), :class => 'menu-item')
  end
  alias ml menu_link
  
  def sidebar_menu(inner_content = nil, &blk)
    content = []
    content << content_for(:sidebar_menu_start) if content_for?(:sidebar_menu_start)
    content << inner_content.to_s if inner_content
    content << capture(&blk) if blk.present?
    content << content_for(:sidebar_menu_end) if content_for?(:sidebar_menu_end)
    content = content_tag(:ul, content.join("").html_safe, :class => 'sidebar-menu')
    content
  end
  
  def sidebar_klass_name(klass)
    controller_i18n_path = controller.controller_path.split("/").join(".")
    tu(controller_i18n_path.to_sym, :scope => 'model_name', :default => klass.model_name.human)
  end
  
  def current_resource_name
    sidebar_klass_name(resource_class).titleize
  end
  
  def current_parent_name
    sidebar_klass_name(parent_class).titleize
  end
  
  def individual_resource_links(r, name = current_resource_name, opts = {}, &blk)
    items = [
      ml("View", resource_url(r)),
      ml("Edit", edit_resource_url(r)),
      ml("Remove", resource_url(r), :method => :delete,
      :confirm => tu(:remove, :scope => :confirm, :object_name => name))
    ]
    if blk.present?
      position = opts.fetch(:at, :before)
      value = capture(&blk)
      position == :before ? items.unshift(value) : items.push(value)
    end
    content_tag(:ul, items.join.html_safe)
  end
  
  def default_collection_columns
    klass = resource_class
    if klass.const_defined?(:INDEX_COLUMNS)
      klass::INDEX_COLUMNS
    else
      klass.column_names - [:created_at, :updated_at]
    end
  end
  
  def empty_row_for_collection(size = default_collection_columns.size)
    return if collection.present?
    name = current_resource_name
    inner = content_tag :td, tu(:empty_row, :object_name => name.downcase, :plural_object_name => name.pluralize.downcase), :colspan => (size + 1)
    content_tag :tr, inner, :class => 'empty'
  end
  
  # Generalized Sidebar Content
  
  def parent_sidebar_content
    with_safe_buffer do |content|
      if respond_to?(:parent?) && parent?
        parent_name = current_parent_name
        content << ml("View #{parent_name}", parent_url)
        content << ml("Edit #{parent_name}", File.join(parent_url, 'edit'))
      end
    end
  end
  
  def resources_sidebar_content(name = current_resource_name)
    with_safe_buffer do |content|
      content << ml("All #{name.pluralize}", collection_url)
      content << ml("Add #{name}", new_resource_url)
    end
  end
  
  def resource_sidebar_content(name = current_resource_name)
    with_safe_buffer do |content|
      content << ml("View #{name}", resource_url)
      content << ml("Edit #{name}", edit_resource_url)
      content << ml("Remove #{name}", resource_url, :method => :delete,
        :confirm => tu(:remove, :scope => :confirm, :object_name => name))
    end
  end
  
  def humanized_errors_on(object)
    if object.errors[:base].present?
      prefix       = "This #{object.class.model_name.human}"
      errors       = content_tag(:p, "Please correct the following errors before continuing:")
      inner_errors = object.errors[:base].map { |e| content_tag(:li, e) }.sum(ActiveSupport::SafeBuffer.new)
      errors      << content_tag(:ul, inner_errors)
      content_tag(:div, errors, :class => 'resource-base-errors')
    end
  end
  
  def with_safe_buffer(&blk)
    ActiveSupport::SafeBuffer.new.tap(&blk)
  end
  
end
