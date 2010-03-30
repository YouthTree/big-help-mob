class AddPickupAtToMissionPickups < ActiveRecord::Migration
  def self.up
    add_column :mission_pickups, :pickup_at, :datetime
  end

  def self.down
    remove_column :mission_pickups, :pickup_at
  end
end
