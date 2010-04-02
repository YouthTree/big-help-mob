class AddCommentToMissionPickup < ActiveRecord::Migration
  def self.up
    add_column :mission_pickups, :comment, :text
  end

  def self.down
    remove_column :mission_pickups, :comment
  end
end
