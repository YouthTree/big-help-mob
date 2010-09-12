class AddVolunteeringInfoToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :volunteered_in_last_year, :boolean
  end

  def self.down
    remove_column :users, :volunteered_in_last_year
  end
end
