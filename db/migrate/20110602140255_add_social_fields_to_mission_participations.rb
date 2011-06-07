class AddSocialFieldsToMissionParticipations < ActiveRecord::Migration
  def self.up
    add_column :mission_participations, :partaking_with_friends, :boolean
  end

  def self.down
    remove_column :mission_participations, :partaking_with_friends
  end
end
