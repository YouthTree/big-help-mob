class FormtasticWithButtonsBuilder < Formtastic::SemanticFormBuilder
  
  def submit(value = "Save changes", options = {})
    @template.content_tag(:button, value, options.reverse_merge(:type => "submit", :id => "#{object_name}_submit"))
  end
  
  # Generates a label, using a safe buffer and a few other things along those lines.
  def label(*args)
    super(*args).gsub(/\?\s*\:\<\/label\>/, "?</label>").gsub(/\?\s*\:\s*\<abbr/, "? <abbr")
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
      at     = c.pickup_at
      value  = c.id
      pickup = c.pickup
      input_id = generate_html_id(input_name, value.to_s.gsub(/\s/, '_').gsub(/\W/, '').downcase)
      input_ids << input_id

      html_options[:checked] = selected_value == value if selected_option_is_present

      inner_label = template.content_tag(:span, pickup.name, :class => 'pickup-name')
      if at.present?
        inner_label << template.content_tag(:span, " at ", :class => 'pickup-time-joiner')
        inner_label << template.content_tag(:span, ::I18n.l(at, :format => :pickup_time), :class => 'pickup-time')
      end
      li_content = template.content_tag(:label,
        "#{self.radio_button(input_name, value, html_options)} #{inner_label}".html_safe,
        :for => input_id
      )

      li_options = value_as_class ? { :class => [method.to_s.singularize, value.to_s.downcase].join('_') } : {}
      li_options.merge!(template.pickup_data_options(c, html_options[:checked]))
      template.content_tag(:li, li_content, li_options)
    end

    field_set_and_list_wrapping_for_pickups(method, options, list_item_content)
  end
  
  
  # The same as normal for methods (e.g. radio buttons etc), but has a correct id for the pickup method.
  def field_set_and_list_wrapping_for_pickups(method, options, contents)
    contents = contents.join if contents.respond_to?(:join)

    template.content_tag(:fieldset,
        template.content_tag(:legend,
            self.label(method, options_for_label(options).merge(:for => options.delete(:label_for))), :class => 'label'
          ) <<
        template.content_tag(:ol, contents.html_safe, :id => "pickups-listing")
      )
  end
  
  def first_and_last_name_input(method, options)
    html_options = options.delete(:input_html) || {}
    first_name_options = (options.delete(:first_name) || {}).reverse_merge! :placeholder => "First Name", :class => 'first-name first-field'
    last_name_options = (options.delete(:last_name) || {}).reverse_merge! :placeholder => "Last Name", :class => 'last-name'
    html_options = default_string_options(method, :string).merge(html_options)
    text = label(:first_name, options_for_label(options))
    text << text_field(:first_name, html_options.merge(first_name_options))
    text << text_field(:last_name, html_options.merge(last_name_options))
    text
  end
  
  def confirmed_password_input(method, options)
    html_options = options.delete(:input_html) || {}
    confirmation_options = (options.delete(:confirmation) || {}).reverse_merge(html_options)
    html_options = default_string_options(method, :password).merge(html_options)
    text = label(method, options_for_label(options))
    text << password_field(method, html_options.merge(html_options).merge(:class => 'first-field'))
    text << password_field(:"#{method}_confirmation", html_options.merge(confirmation_options))
    text
  end
  
  def dob_input(*args)
    options = args.extract_options!
    options.merge!(:start_year => (Time.now.year - 100), :end_year => Time.now.year, :selected => nil)
    args << options
    date_input(*args)
  end
  
  def commit_button_with_cancel(*args)
    options = args.extract_options!
    text = options.delete(:label) || args.shift
    cancel_options = options.delete(:cancel)

    if @object && @object.respond_to?(:new_record?)
      key = @object.new_record? ? :create : :update
      
      # Deal with some complications with ActiveRecord::Base.human_name and two name models (eg UserPost)
      # ActiveRecord::Base.human_name falls back to ActiveRecord::Base.name.humanize ("Userpost") 
      # if there's no i18n, which is pretty crappy.  In this circumstance we want to detect this
      # fall back (human_name == name.humanize) and do our own thing name.underscore.humanize ("User Post")
      if @object.class.model_name.respond_to?(:human)
        object_name = @object.class.model_name.human
      else
        object_human_name = @object.class.human_name                # default is UserPost => "Userpost", but i18n may do better ("User post")
        crappy_human_name = @object.class.name.humanize             # UserPost => "Userpost"
        decent_human_name = @object.class.name.underscore.humanize  # UserPost => "User post"
        object_name = (object_human_name == crappy_human_name) ? decent_human_name : object_human_name
      end
    else
      key = :submit
      object_name = @object_name.to_s.send(self.class.label_str_method)
    end

    text = (self.localized_string(key, text, :action, :model => object_name) ||
            ::Formtastic::I18n.t(key, :model => object_name)) unless text.is_a?(::String)

    button_html = options.delete(:button_html) || {}
    button_html.merge!(:class => [button_html[:class], key].compact.join(' '))
    element_class = ['commit', options.delete(:class)].compact.join(' ') # TODO: Add class reflecting on form action.
    accesskey = (options.delete(:accesskey) || self.class.default_commit_button_accesskey) unless button_html.has_key?(:accesskey)
    button_html = button_html.merge(:accesskey => accesskey) if accesskey
    inner = Formtastic::Util.html_safe(self.submit(text, button_html))
    # Start custom code
    if cancel_options.present?
      inner << template.content_tag(:span, "or", :class => "or")
      inner << @template.link_to(cancel_options.delete(:text), cancel_options.delete(:url), cancel_options)
    end
    # End custom code
    template.content_tag(:li, inner, :class => element_class)
  end
  
  # Returns errors converted to a sentence, adding a full stop.
  def error_sentence(errors, options = {})
    error_class = options[:error_class] || self.class.default_inline_error_class
    error_text = errors.to_sentence.untaint.strip
    error_text << "." unless %w(? ! . :).include?(error_text[-1, 1])
    template.content_tag(:p, Formtastic::Util.html_safe(error_text), :class => error_class)
  end
  
  
  def datetime_picker_input(method, options = {})
    format = (options[:format] || Time::DATE_FORMATS[:default] || '%d %B %Y %I:%M %p')
    string_input(method, datetime_picker_options(format, object.send(method)).merge(options))
  end
  
  def date_picker_input(method, options = {})
    format = (options[:format] || Time::DATE_FORMATS[:default] || '%d %B %Y')
    string_input(method, date_picker_options(format, object.send(method)).merge(options))
  end
  
  def date_range_picker_input(method, options = {})
    format = (options[:format] || Time::DATE_FORMATS[:default] || '%d %B %Y')
    gte_method, lte_method = :"#{method}_gte", :"#{method}_lte"
    add_input_html_options!(options) { |ho| ho[:class] = [ho[:class], 'ui-date-picker'].join(' ').strip }
    basic_field_range_helper(method, lte_method, gte_method, options) do |value|
      value.try :strftime, format
    end
  end
  
  def datetime_range_picker_input(method, options = {})
    format = (options[:format] || Time::DATE_FORMATS[:default] || '%d %B %Y %I:%M %p')
    gte_method, lte_method = :"#{method}_gte", :"#{method}_lte"
    add_input_html_options!(options) { |ho| ho[:class] = [ho[:class], 'ui-datetime-picker'].join(' ').strip }
    basic_field_range_helper(method, lte_method, gte_method, options) do |value|
      value.try :strftime, format
    end
  end

  def placeholder_for(field, default = nil)
    result = localized_string field, default, :placeholder
    result.present? ? result : nil
  end

  protected

  def basic_field_range_helper(method, low_end, high_end, options, &blk)
    html_options    = options.delete(:input_html) || {}
    minimum_options = options.delete(:minimum_html) || {}
    maximum_options = options.delete(:maximum_html) || {}
    label_options   = options_for_label(options).merge(:for => generate_html_id(low_end, ''))
    low_end_options = with_placeholder(low_end, html_options.merge(minimum_options).merge(:value => blk.call(object.try(low_end))))
    high_end_options = with_placeholder(high_end, html_options.merge(maximum_options).merge(:value => blk.call(object.try(high_end))))
    input = label(method, label_options)
    input << @template.content_tag(:span, 'Between ')
    input << text_field(low_end, low_end_options)
    input << @template.content_tag(:span, ' and ')
    input << text_field(high_end, high_end_options)
    input
  end
  
  def with_placeholder(method, options)
    placeholder = placeholder_for(method, options.delete(:placeholder))
    options[:placeholder] = placeholder if placeholder.present?
    options
  end

  def add_input_html_options!(options, extra = {})
    input_html = options.delete(:input_html) || {}
    yield input_html if block_given?
    options[:input_html] = input_html.merge(extra)
    options
  end

  def datetime_picker_options(format, value = nil)
    input_options   = {:class => 'ui-datetime-picker',:value => value.try(:strftime, format)}
    return :input_html => input_options
  end
  
  def date_picker_options(format, value = nil)
    input_options   = {:class => 'ui-date-picker',:value => value.try(:strftime, format)}
    return :input_html => input_options
  end
    
end