module ApplicationHelper
  
  def tu(name, options = {})
    scope = [:ui, options.delete(:scope)].compact.join(".").to_sym
    I18n.t(name, options.merge(:scope => scope))
  end
  
  def flash_messages(*names)
    names = names.select { |k| flash[k].present? }
    return if names.blank?
    content = []
    names.each_with_index do |key, idx|
      value = flash[key]
      first, last = (idx == 0), (idx == names.length - 1)
      content << content_tag(:p, value, :class => "flash #{key} #{"first" if first} #{"last" if last}".strip)
    end
    content_tag(:section, content.sum(ActiveSupport::SafeBuffer.new), :id => "flash-messages").html_safe
  end
  
  def pickup_data_options(pickup, selected = false)
    opts = {"class" => "pickup-entry"}
    opts["data-pickup-id"] = pickup.id
    if pickup.is_a?(MissionPickup)
      opts["data-pickup-comment"] = pickup.comment if pickup.comment.present?
      opts["data-pickup-at"]      = I18n.l(pickup.pickup_at, :format => :pickup_time)
      pickup = pickup.pickup
    end
    opts["title"] = pickup.address.to_s
    opts["data-pickup-latitude"]  = pickup.address.lat
    opts["data-pickup-longitude"] = pickup.address.lng
    opts["data-pickup-selected"]  = pickup.id if selected
    opts["data-pickup-name"]      = pickup.name
    opts["data-pickup-address"]   = pickup.address.to_s
    opts
  end
  
  def render_address_fields(f, name = :address, options = {})
    o = f.object
    o.send(:"build_#{name}") if o.send(name).blank?
    ActiveSupport::SafeBuffer.new.tap do |html|
      f.fields_for(name) do |af|
        html << render(:partial => 'shared/address_fields', :locals => {:form => af, :options => options})
      end
    end
  end
  
  protected
  
  def normalized_content_scope(key, scope = nil)
    (Array(scope) + key.to_s.split(".")).flatten.join(".")
  end
  
  def options_with_class_merged(o, n)
    css_klass = [o[:class], n[:class]].join(" ").strip.squeeze(" ")
    o.merge(n).merge(:class => css_klass)
  end
  
end
