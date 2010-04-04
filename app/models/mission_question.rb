class MissionQuestion < ActiveRecord::Base
  
  QUESTION_TYPES   = %w(boolean short_text text multiple_choice)
  VALID_ROLE_NAMES = %w(all captain sidekick)
  
  def self.types_for_select
    QUESTION_TYPES.map { |v| [v.humanize, v] }
  end
  
  def self.roles_for_select
    [["All Users", "all"], ["Captains", "captain"], ["Sidekicks", "sidekick"]]
  end
  
  belongs_to :mission
  
  validates_presence_of  :name
  validates_inclusion_of :question_type, :in => QUESTION_TYPES, :message => "is not a valid type of question"
  validates_presence_of  :metadata, :if => :multiple_choice?
  
  serialize :metadata
  
  def to_formtastic_options(answers = nil)
    required = required_by_role == "all" || (answers && answers.required?(self))
    options = if multiple_choice?
      {:as => :select, :collection => Array(metadata)}
    elsif boolean?
      {:as => :select, :collection => ["Yes", "No"], :include_blank => false}
    elsif short_text?
      {:as => :string}
    else
      {:as => :text, :input_html => {:rows => 5}}
    end
    options.merge(:label => name, :required => required, :wrapper_html => {:class => "mission-question-#{question_type.dasherize}"})
  end
  
  def raw_metadata=(value)
    if value.blank?
      value = nil
    elsif value.is_a?(String)
      value = value.split("\n").map { |i| i.strip }.reject(&:blank?)
    end
    self.metadata = value
  end
  
  def raw_metadata
    if metadata.is_a?(Array)
      metadata.join("\n")
    else
      metadata.to_s
    end
  end
  
  QUESTION_TYPES.each do |type|
    define_method(:"#{type}?") { question_type == type }
  end
  
  def viewable_by?(role)
    ["all", role.to_s].include? viewable_by_role
  end
  
  def required_by?(role)
    ["all", role.to_s].include? required_by_role
  end
  
end

# == Schema Info
#
# Table name: mission_questions
#
#  id            :integer(4)      not null, primary key
#  mission_id    :integer(4)
#  default_value :string(255)
#  metadata      :text
#  name          :string(255)
#  question_type :string(255)
#  required      :boolean(1)
#  created_at    :datetime
#  updated_at    :datetime