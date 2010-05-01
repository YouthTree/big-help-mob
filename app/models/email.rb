class Email
  include ActiveModel::Conversion
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON
  extend  ActiveModel::Naming
  
  class BlankRenderer
    def initialize(repl = ""); @repl = repl; end
    def render(scope = {}); @repl; end
  end
  
  SCOPE_TYPES = [["All Users", "users"], ["Filtered Participations", "participations"]]
  
  ASSIGNABLE_ATTRIBUTES = [:subject, :html_content, :text_content, :scope_type, :filter, :confirmed]
  attr_accessor           *ASSIGNABLE_ATTRIBUTES
  define_attribute_methods ASSIGNABLE_ATTRIBUTES
  
  validates_presence_of  :subject
  validates_inclusion_of :scope_type, :in => SCOPE_TYPES.map(&:last)
  validate               :has_atleast_one_content_type
  validate               :has_atleast_one_user
  validate               :ensure_confirmed_is_checked
  
  def initialize(attributes = {})
    self.attributes = attributes
    @template_cache = {}
  end
  
  def attributes=(attributes)
    return unless attributes.is_a?(Hash)
    @template_cache = {}
    attributes.symbolize_keys.each_pair do |k, v|
      send :"#{k}=", v if ASSIGNABLE_ATTRIBUTES.include? k.to_sym
    end
  end
  
  def attributes
    @attributes ||= ASSIGNABLE_ATTRIBUTES.inject({}) { |m, c| m[c.to_s] = 'nil'; m }
  end
  
  def filter
    @filter ||= OpenStruct.new
  end
  
  def filter=(value)
    if value.blank? || !value.is_a?(Hash)
      @filter = OpenStruct.new
    else
      value = value["table"] if value.keys == ["table"]
      @filter = OpenStruct.new(value.stringify_keys)
      @filter.mission_id = @filter.mission_id.to_i if @filter.mission_id.present?
    end
  end
  
  def save
    valid? && send_email
  end
  
  def persisted?
    false
  end
  
  def confirmed=(value)
    if value.blank?
      @confirmed = nil
    else
      @confirmed = ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value.to_s)
    end
  end
  
  def confirmed?
    !!@confirmed
  end
  
  def send_email
    Rails.logger.debug self.to_json
    if [html_content, text_content, subject].any? { |c| c.include?("{{") }
      IndividualUserMailer.queue_for!(self)
    else
      BulkUserMailer.queue_for!(self)
    end
    true
  end
  
  def self.mapping_to_scope(name, filter)
    name  = name.to_s
    scope = User.unscoped
    scope = scope.where('id IN (?)', build_id_list(filter)) if name == "participations"
    scope
  end
  
  def self.build_id_list(filter)
    scope = MissionParticipation.unscoped
    scope = scope.where('mission_id = ?', filter.mission_id.to_i) if filter.mission_id.present?
    scope = scope.only_role(filter.role)       if filter.role.present?
    scope = scope.with_states(filter.states)   if filter.states.present?
    scope = scope.from_pickups(filter.pickups) if filter.pickups.present?
    scope.select(:user_id).all.map(&:user_id).uniq
  end
  
  def valid_other_than_confirmed?
    errors.reject { |k, v| v.blank? }.map { |k, v| k } == [:confirmed]
  end
  
  def user_count
    user_scope.count
  end
  
  def emails
    user_scope.select(:email).map(&:email).uniq
  end
  
  def self.from_json(json)
    allocate.from_json(json)
  end
  
  def each_user
    user_scope.find_each { |u| yield u } if block_given?
  end
  
  def example_rendered_email
    @template_cache[:rendered] ||= begin
      user = user_scope.first
      rendered_email_for(user)
    end
  end
  
  def rendered_email_for(user)
    scope = scope_for_user(user)
    self.dup.tap do |e|
      e.subject      = template_for_subject.render(scope)
      e.text_content = template_for_text_content.render(scope)
      e.html_content = template_for_html_content.render(scope)
    end
  end
  
  %w(subject html_content text_content).each do |name|
    define_method :"template_for_#{name}" do
      @template_cache[name] ||= template_for(send(name.to_sym))
    end
  end
  
  def scope_for_user(user)
    scope = {'user' => user}
    if scope_type == 'participations'
      if filter.mission_id.present?
        scope['participation'] = user.mission_participations.find_by_mission_id(filter.mission_id)
      end
    end
    scope
  end
  
  protected

  def template_for(content)
    content.blank? ? BlankRenderer.new : Liquid::Template.parse(content)
  rescue Liquid::SyntaxError
    BlankRenderer.new("ERROR IN TEMPLATE")
  end

  def user_scope
    self.class.mapping_to_scope(scope_type, filter)
  end
  
  def has_atleast_one_content_type
    if html_content.blank? && text_content.blank?
      errors.add :html_content, "at least one content section must be filled in"
      errors.add :text_content, "at least one content section must be filled in"
    end
  end
  
  def has_atleast_one_user
    errors.add_to_base "The chosen filter doesn't match any users" if user_scope.size < 1
  end
  
  def ensure_confirmed_is_checked
    errors.add :confirmed, "Please confirm this is the correct number of users" unless confirmed?
  end
  
end