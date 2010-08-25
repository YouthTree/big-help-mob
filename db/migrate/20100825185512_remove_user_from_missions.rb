class RemoveUserFromMissions < ActiveRecord::Migration
  def self.up
    remove_column :missions, :user_id
  end

  def self.down
    add_column :missions, :user_id, :integer
  end
end
