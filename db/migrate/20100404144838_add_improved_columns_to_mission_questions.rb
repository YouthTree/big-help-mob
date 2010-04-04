class AddImprovedColumnsToMissionQuestions < ActiveRecord::Migration
  def self.up
    add_column    :mission_questions, :required_by_role,  :string
    add_column    :mission_questions, :viewable_by_role, :string, :default => "all"
    remove_column :mission_questions, :required
  end

  def self.down
    add_column    :mission_questions, :required, :boolean
    remove_column :mission_questions, :viewable_by_role
    remove_column :mission_questions, :required_by_role
  end
end
