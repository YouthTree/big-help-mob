class Answers
  extend  ActiveModel::Naming
  include ActiveModel::Validations
  
  VALID_NAME_REGEXP = /^question_\d+\=?$/
  
  validate :check_answer_status
  
  def self.i18n_scope
    :answer_model
  end
  
  attr_reader :participation, :mission, :questions
  
  def initialize(participation)
    @participation = participation
    @mission       = participation.mission
    @questions     = @mission.try(:questions) || []
  end
  
  def attributes=(attributes)
    attributes.each_pair do |k, v|
      write_attribute(k, v) if k.to_s =~ VALID_NAME_REGEXP
    end
  end
  
  def each_question(&blk)
    @questions.each do |question|
      yield question, question_to_param(question)
    end
  end
  
  def each_viewable_question(&blk)
    role = @participation.role_name
    each_question { |q, p| yield q, p if q.viewable_by?(role) }
  end
  
  def each_answer(&blk)
    each_question { |q, p| yield read_attribute(p) }
  end
  
  def answers
    @answers ||= begin
      value = @participation.raw_answers
      if !value.is_a?(Hash)
        value = {}
        @participation.raw_answers = value
      end
      value
    end
  end
  
  def needed?
    !@questions.empty?
  end
  
  def write_attribute(name, value)
    answers[name.to_s] = normalize_value(question_for_name(name), value)
  end
  
  def read_attribute(name)
    v = answers[name.to_s]
    return v if v.present?
    if (q = question_for_name(name)).present?
      return q.default_value
    end
    nil
  end
  
  def question_for_name(name)
    @questions.detect { |q| q.id == param_to_id(name) }
  end
  
  def method_missing(name, *args, &blk)
    if (question = question_for_name(name)).present?
      name = name.to_s
      assign = name[-1, 1] == "="
      assign ? write_attribute(name[0..-2], *args) : read_attribute(name)
    else
      super
    end
  end
  
  def respond_to?(name, include_private = false)
    !!(name.to_s =~ VALID_NAME_REGEXP) || super
  end
  
  def check_answer_status
    each_question do |question, key|
      value = read_attribute(key)
      required = required?(question)
      if value.blank? && required
        errors.add(key, :blank, :default => "is blank")
      elsif required && question.boolean? && value =~ /no/i
        errors.add(key, :voided_participation)
      elsif value.present? && question.multiple_choice?
        valid_choice = Array(question.metadata).include?(value)
        errors.add(key, :invalid_choice) unless valid_choice
      end
    end
  end
  
  def required?(q)
    q.required_by?(@participation.role_name)
  end
  
protected #####################################################################
  
  def question_to_param(question, suffix = "")
    :"question_#{question.id}#{suffix}"
  end
  
  def param_to_id(id)
    id.to_s.scan(/\d+/).first.to_i
  end
  
  def normalize_value(question, value)
    value.to_s
  end
  
end
