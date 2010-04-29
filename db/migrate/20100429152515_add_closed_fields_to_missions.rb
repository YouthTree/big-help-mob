class AddClosedFieldsToMissions < ActiveRecord::Migration
  def self.up
    add_column :missions, :captain_signup_open,  :boolean, :default => true
    add_column :missions, :sidekick_signup_open, :boolean, :default => true
  end

  def self.down
    remove_column :missions, :sidekick_signup_open
    remove_column :missions, :captain_signup_open
  end
end
