class FormtasticWithButtonsBuilder < Formtastic::SemanticFormBuilder
  
  def submit(value = "Save changes", options = {})
    @template.content_tag(:button, value, options.reverse_merge(:type => "submit", :id => "#{object_name}_submit"))
  end
  
  def label(method, options_or_text=nil, options=nil)
    if options_or_text.is_a?(Hash)
      return "" if options_or_text[:label] == false
      options = options_or_text
      text = options.delete(:label)
    else
      text = options_or_text
      options ||= {}
    end
    
    text = create_safe_buffer do |buffer|
      buffer << (localized_string(method, text, :label) || humanized_attribute_name(method))
      buffer << required_or_optional_string(options.delete(:required))
    end

    # special case for boolean (checkbox) labels, which have a nested input
    text = create_safe_buffer { |b| b << (options.delete(:label_prefix_for_nested_input) || "") } + text
    input_name = options.delete(:input_name) || method
    super(input_name, text, options).gsub(/\?\s*\:\<\/label\>/, "?</label>").gsub(/\?\s*\:\s*\<abbr/, "? <abbr")
  end
  
  def boolean_input(method, options)
    super.gsub(":</label>", "</label>").gsub(": <abbr", " <abbr")
  end
  
  def pickups_input(method, options)
    collection   = options.delete(:collection) || []
    html_options = strip_formtastic_options(options).merge(options.delete(:input_html) || {})

    input_name = generate_association_input_name(method)
    value_as_class = options.delete(:value_as_class)
    input_ids = []
    selected_option_is_present = [:selected, :checked].any? { |k| options.key?(k) }
    selected_value = (options.key?(:checked) ? options[:checked] : options[:selected]) if selected_option_is_present

    list_item_content = collection.map do |c|
      value = c.id
      input_id = generate_html_id(input_name, value.to_s.gsub(/\s/, '_').gsub(/\W/, '').downcase)
      input_ids << input_id
      
      html_options[:checked] = selected_value == value if selected_option_is_present
      li_content = template.content_tag(:label,
        "#{self.radio_button(input_name, value, html_options)} #{c.name}",
        :for => input_id
      )

      li_options = value_as_class ? { :class => [method.to_s.singularize, value.to_s.downcase].join('_') } : {}
      template.content_tag(:li, li_content, li_options.merge(@template.pickup_data_options(c, html_options[:checked])))
    end

    field_set_and_list_wrapping_for_pickups(method, options.merge(:label_for => input_ids.first), list_item_content)
  end
  
  def field_set_and_list_wrapping_for_pickups(method, options, contents) #:nodoc:
    contents = contents.join if contents.respond_to?(:join)

    template.content_tag(:fieldset,
        template.content_tag(:legend,
            self.label(method, options_for_label(options).merge(:for => options.delete(:label_for))), :class => 'label'
          ) <<
        template.content_tag(:ol, contents, :id => "pickups-listing")
      )
  end
  
  
  def commit_button(*args)
    options = args.extract_options!
    text = options.delete(:label) || args.shift
    cancel_options = options.delete(:cancel)
    if @object
      key = @object.new_record? ? :create : :update
      object_name = @object.class.model_name.human
    else
      key = :submit
      object_name = @object_name.to_s.send(@@label_str_method)
    end

    text = (self.localized_string(key, text, :action, :model => object_name) ||
            ::Formtastic::I18n.t(key, :model => object_name)) unless text.is_a?(::String)

    button_html = options.delete(:button_html) || {}
    button_html.merge!(:class => [button_html[:class], key].compact.join(' '))
    element_class = ['commit', options.delete(:class)].compact.join(' ') # TODO: Add class reflecting on form action.
    accesskey = (options.delete(:accesskey) || @@default_commit_button_accesskey) unless button_html.has_key?(:accesskey)
    button_html = button_html.merge(:accesskey => accesskey) if accesskey 
    inner = self.submit(text, button_html)
    if cancel_options.present?
      inner << @template.content_tag(:span, "or", :class => "or")
      inner << @template.link_to(cancel_options.delete(:text), cancel_options.delete(:url), cancel_options)
    end
    template.content_tag(:li, inner, :class => element_class)
  end
  
  
  protected
  
  def create_safe_buffer
    buffer = defined?(ActiveSupport::SafeBuffer) ? ActiveSupport::SafeBuffer.new : ""
    yield buffer if block_given?
    buffer
  end
    
end