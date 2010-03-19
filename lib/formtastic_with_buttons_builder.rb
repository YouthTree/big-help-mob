class FormtasticWithButtonsBuilder < Formtastic::SemanticFormBuilder
  
  def submit(value = "Save changes", options = {})
    @template.content_tag(:button, value, options.reverse_merge(:id => "#{object_name}_submit"))
  end
  
  def boolean_input(method, options)
    super.gsub(":</label>", "</label>").gsub(": <abbr", " <abbr")
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
    super(input_name, text, options)
  end
  
  protected
  
  def create_safe_buffer
    buffer = defined?(ActiveSupport::SafeBuffer) ? ActiveSupport::SafeBuffer.new : ""
    yield buffer if block_given?
    buffer
  end
    
end