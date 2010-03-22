class AddPickupIdToMissionParticipations < ActiveRecord::Migration
  def self.up
    add_column :mission_participations, :pickup_id, :integer
  end

  def self.down
    remove_column :mission_participations, :pickup_id
  end
end
