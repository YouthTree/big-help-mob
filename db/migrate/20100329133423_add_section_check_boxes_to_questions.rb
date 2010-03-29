class AddSectionCheckBoxesToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :show_on_mission_page,     :boolean, :default => false
    add_column :questions, :show_on_sidekick_section, :boolean, :default => false
    add_column :questions, :show_on_captain_section,  :boolean, :default => false
  end

  def self.down
    remove_column :questions, :show_on_captain_section
    remove_column :questions, :show_on_sidekick_section
    remove_column :questions, :show_on_mission_page
  end
end
