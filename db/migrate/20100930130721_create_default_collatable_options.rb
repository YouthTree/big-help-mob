class CreateDefaultCollatableOptions < ActiveRecord::Migration
  
  INITIAL_COLLATABLE_OPTIONS = [
    ["What habit? (I haven't really volunteered before)", "never"],
    ["I volunteered 3 times or less in the last 12 months", "3-or-less-times"],
    ["I volunteer once a month", "once-per-month"],
    ["I volunteer once a week", "once-per-week"],
    ["I've practically got a degree in volunteering (I volunteer more than twice a week)", "two-plus-per-week"]
  ]
  
  def self.up
    INITIAL_COLLATABLE_OPTIONS.each do |set|
      CollatableOption.create! :scope_key => 'user.volunteering_history', :name => set[0], :value => set[1]
    end
  end

  def self.down
    CollatableOption.where(:scope_key => 'user.volunteering_history', :value => INITIAL_COLLATABLE_OPTIONS.map { |i| i.last }).delete_all
  end
end
