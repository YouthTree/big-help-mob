class ParticipationReporter
  
  def self.csv_class
    @csv_class ||= begin
      if RUBY_VERSION < '1.9'
        FasterCSV
      else
        require 'csv'
        CSV
      end
    end
  end
  
  ROLE_CHOICES = [
    ["All Participations", ""],
    ["Captains only",      "captain"],
    ["Sidekicks only",     "sidekick"]
  ]
  
  STATE_CHOICES = MissionParticipation.state_machine.states.map { |s| [s.name.to_s.humanize, s.value] }
  
  DEFAULTS = {
    :title      => true,
    :role_name  => true,
    :state      => true,
    :headers    => true,
    :first_name => true,
    :last_name  => true,
    :email      => true,
    :pickup     => true,
    :states     => STATE_CHOICES.map(&:last)
  }
  
  attr_reader :mission, :collection
  
  def self.pickups_for(mission)
    mission.mission_pickups.map { |p| [p.name, p.id] }
  end
  
  def self.default_for(key)
    DEFAULTS[key.to_sym]
  end

  def initialize(mission, options = {})
    @options    = (options.is_a?(Hash) ? options : {}).symbolize_keys
    @mission    = mission
    @collection = scope_participations(mission).all(:include => {:role => nil, :user => nil, :pickup => {:pickup => :address}})
  end
  
  def show?(key)
    key = key.to_sym
    if @options.has_key?(key)
      ActiveRecord::ConnectionAdapters::Column.value_to_boolean(@options[key])
    else
      !!DEFAULTS[key.to_sym]
    end
  end
  
  def to_csv
    self.class.csv_class.generate do |csv|
      csv << generate_header if show?(:headers)
      @collection.each { |r| csv << generate_row(r) }
    end
  end
  
  def generate_header
    [].tap do |header|
      [:name, :dob].each { |f| header << tl(f) }
      [:email, :first_name, :last_name, :pickup, :mailing_address, :phone, :allergies, :role_name, :state, :user_comment, :participation_comment].each do |key|
        append_header_entry header, key
      end
      mission.questions.each { |q| header << tl(:answer, :name => q.name)  } if show?(:answers)
      if show?(:captain_application)
        [:reason_why, :offers, :has_first_aid_cert].each do |field|
          header << tl("captain_application.#{field}")
        end
      end
    end
  end
  
  def generate_row(participation)
    user = participation.user
    captain_application = user.captain_application
    [].tap do |row|
      row << user.name
      row << (user.date_of_birth.present? ? I18n.l(user.date_of_birth) : "Unknown")
      append_row_entry row, user, :email
      append_row_entry row, user, :first_name
      append_row_entry row, user, :last_name
      append_row_entry row, participation, :pickup, :humanized_pickup
      append_row_entry row, user, :mailing_address
      append_row_entry row, user, :phone
      append_row_entry row, user, :allergies
      append_row_entry row, participation, :role_name
      append_row_entry row, participation, :state, :human_state_name
      append_row_entry row, user, :user_comment, :comment
      append_row_entry row, participation, :participation_comment, :comment
      participation.answers.each_answer { |v| row << v } if show?(:answers)
      if show?(:captain_application)
        if participation.captain?
          [:reason_why, :offers, :has_first_aid_cert].each do |field|
            row << captain_application.try(field).to_s
          end
        else
          row += ["", "", ""]
        end
      end
    end
  end
  
  protected
  
  def scope_participations(mission)
    scope = mission.mission_participations
    scope = scope.only_role(@options[:role])      if @options[:role].present?
    scope = scope.with_states(@options[:states])  if @options[:states].present?
    scope = scope.from_pickups(@options[:pickups]) if @options[:pickups].present?
    scope
  end
  
  def tl(name, opts = {})
    ::I18n.t(name.to_sym, opts.merge(:scope => 'ui.participation_reporter.labels'))
  end
  
  def append_header_entry(collection, key)
    collection << tl(key) if show?(key)
  end
  
  def append_row_entry(row, source, key, m = key)
    row << source.send(m).to_s if show?(key)
  end
  
end