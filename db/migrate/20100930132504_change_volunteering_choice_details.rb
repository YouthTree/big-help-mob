class ChangeVolunteeringChoiceDetails < ActiveRecord::Migration
  def self.up
    remove_column :users, :volunteered_in_last_year
    add_column :users, :volunteering_history_id, :integer
  end

  def self.down
    add_column :users, :volunteered_in_last_year, :boolean
    remove_column :users, :volunteering_history_id
  end
end
