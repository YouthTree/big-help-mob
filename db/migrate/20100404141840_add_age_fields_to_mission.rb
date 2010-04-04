class AddAgeFieldsToMission < ActiveRecord::Migration
  def self.up
    add_column :missions, :minimum_sidekick_age, :integer
    add_column :missions, :maximum_sidekick_age, :integer
    add_column :missions, :minimum_captain_age, :integer
    add_column :missions, :maximum_captain_age, :integer
  end

  def self.down
    remove_column :missions, :maximum_captain_age
    remove_column :missions, :minimum_captain_age
    remove_column :missions, :maximum_sidekick_age
    remove_column :missions, :minimum_sidekick_age
  end
end
